# PhoodApp — Instructions pour Claude Code

## Contexte
Application web sur-mesure pour **Phood Restaurant** (Begles, centre commercial) remplacant inpulse.ai.
Gestion des commandes fournisseurs, recettes, stocks, previsions de ventes, factures, rentabilite multi-canal.

## Cahier des charges
**LIRE EN PREMIER** : `CAHIER_DES_CHARGES.md` (dans ce meme dossier)
Contient TOUTES les specifications fonctionnelles, techniques, UX et le modele de donnees.

## Statut V1 : PRET POUR PRODUCTION (~92%)

Tous les modules principaux sont implementes et fonctionnels. Voir section "Statut implementation" en bas de ce fichier pour le detail.

## Stack technique
| Composant | Technologie | Details |
|---|---|---|
| Frontend | Vue.js 3 (Composition API) + Vite + Pinia | PWA avec offline (IndexedDB via Dexie.js + Service Worker) |
| Hebergement | Netlify | CDN statique + 13 Serverless Functions + scheduled functions |
| Base de donnees | Supabase (PostgreSQL) | 28 tables, RLS par role via `get_my_role()`, pg_cron + pg_net, 15 migrations |
| Auth | Supabase Auth | Email/password + Google OAuth Workspace. Table `profiles` liee a `auth.users`, trigger auto `handle_new_user` |
| Storage | Supabase Storage | 4 buckets prives (bl-photos, anomalies, pdfs, packaging). Compression client-side max 2048px |
| Realtime | Supabase Realtime | Presence channels pour verrouillage commandes (heartbeat 30s, timeout 15 min) |
| CRON | Supabase Edge Functions (Deno) | pg_cron -> pg_net -> 6 Edge Functions. 4 jobs quotidiens (06:00-07:30) + backup |
| IA | OpenAI API (GPT-4.1-mini) | Lecture BL, detection allergenes + extraction ingredients (`contient`), extraction prix, parsing recettes. Structured output JSON strict. Fallback : GPT-4.1 standard |
| Caisse | Zelty API v2.10 | Bearer token. Import CA historique (`/orders`, `/closures`) + sync quotidien |
| Email | Gmail API v1 (Service Account) | Envoi via `team.begles@phood-restaurant.fr`. Service Account + Domain-Wide Delegation + MIME via nodemailer/MailComposer. Auto-BCC sender sur chaque email. Emails visibles dans "Envoyés" Gmail |
| Comptabilite | PennyLane API v2 | Token entreprise lecture seule. Changelog polling quotidien. Detection depannage + rapprochement factures/BL + cout reel |
| Calendrier | Google Calendar API v3 | Meme service account que Gmail. Creation/update evenements livraison a l'envoi/reception commande |
| Horaires | Google Places API (New) | Cle API simple. Place ID Begles : `ChIJRRTmT5gmVQ0Rk4sBmRERCLI`. Remplace GBP API (acces refuse par Google) |
| Meteo | Open-Meteo | Free tier sans cle API. Modeles Meteo-France AROME 1.5km + ARPEGE. Coordonnees : lat=44.83, lon=-0.57 |
| PDF | jsPDF + jspdf-autotable | Generation client-side (~526 KB bundle). Bons de commande brandes Phood. Fonctionne hors-ligne |
| Backup | Google Drive API | Sauvegarde automatique quotidienne des donnees Supabase |
| Calendriers auto | Calcul local + API data.gouv.fr | Jours feries (algo Paques Meeus), vacances scolaires Zone A, soldes (calcul + override) |

> **Combo (planning)** : Integration annulee -- API Partner non accessible avec le plan actuel (plan Time, pas Pro). Repartition horaire du CA calculee nativement via tickets Zelty horodates (section 7.6 du CDC).

## Architecture donnees
```
Ingredient Fournisseur (mercuriale, SKU, conditionnements, prix)
       | (N:1)
Ingredient Restaurant (ce qu'on utilise en cuisine, cout_unitaire auto, contient, allergenes)
       | (1:N)
Recette / Produit Caisse (synchro Zelty, variantes taille, modificateurs extra/sans, prix_vente multi-canal)
```
- Sous-recettes imbriquees jusqu'a **3 niveaux** (sauce -> marinade -> preparation -> plat)
- Sous-recettes = PAS de stock propre, toujours decrementation recursive aux ingredients de base
- Produits sans recette (boissons, snacks) = lien direct ingredient fournisseur
- Champ `contient` sur ingredients achetes tout prets (sauces, preparations) : liste libre de sous-ingredients pour la recherche allergenes

## Conventions
- **Langue** : Francais pour l'UI, anglais pour le code (noms de variables, fonctions, commentaires)
- **iPad-first** : Boutons 48-56px, fonts 18px+, navigation bottom bar, clavier numerique natif
- **Auto-save** : IndexedDB toutes les 5 secondes, sync Supabase quand online (composable `useAutoSave`)
- **Numerotation commandes** : `BC{AAAAMMJJ}-{NNN}` (ex: BC20260303-001)
- **Roles V1** : Admin (full), Manager + Operateur (commandes + reception + allergenes uniquement). Permissions extensibles plus tard
- **CSS** : Variables CSS custom (`--color-primary: #E85D2C`, `--bg-surface`, `--border`, etc.). Pas de framework CSS.
- **State management** : Pinia stores avec pattern online-first + fallback IndexedDB
- **Routing** : Vue Router avec auth guard, lazy-loading des pages

## Architecture fichiers

```
src/
  App.vue                          # Root component
  main.ts                          # Entry point (Pinia, Router, PWA)
  layouts/AppLayout.vue            # Shell layout: sidebar nav + bottom bar + notification bell
  components/NotificationPanel.vue # Bell icon + dropdown notifications
  composables/
    useAuth.ts                     # Auth state, role checks, signOut
    useAutoSave.ts                 # IndexedDB auto-save every 5s
    useLocking.ts                  # Supabase Realtime presence locking
    useOffline.ts                  # Online/offline detection + sync indicator
  lib/
    supabase.ts                    # Supabase client init
    rest-client.ts                 # Generic REST wrapper (GET/POST/PATCH/DELETE/HEAD with count)
    dexie.ts                       # IndexedDB schema (23 tables mirroring Supabase)
    sync-queue.ts                  # Offline mutation queue (auto-flush on reconnect)
    pdf-commande.ts                # PDF generation for order documents
    image-compress.ts              # Client-side image compression (max 2048px)
    calendriers.ts                 # Jours feries, vacances scolaires, soldes (calcul local + API)
    create-notification.ts         # Create notification + optional email alert
  stores/
    commandes.ts                   # Orders CRUD + status machine + calendar sync
    fournisseurs.ts                # Suppliers CRUD
    mercuriale.ts                  # Supplier catalog (SKU, prices, conditionnements)
    ingredients.ts                 # Restaurant ingredients CRUD + search
    recettes.ts                    # Recipes + sub-recipes + cost calc + allergen collection
    stocks.ts                      # Stock levels + decrement/increment
    inventaire.ts                  # Inventory counting (multi-zone, multi-conditionnement)
    previsions.ts                  # Forecasts (weather coefficients, events, N-1 comparison)
    factures.ts                    # PennyLane invoices + reconciliation
    reporting.ts                   # Analytics (CM, top/flop, associations, accuracy)
    notifications.ts               # Notification CRUD + unread count
  modules/
    auth/LoginPage.vue             # Email/password + Google OAuth login
    auth/ResetPasswordPage.vue     # Password reset flow
    dashboard/DashboardPage.vue    # Home dashboard with KPIs
    dashboard/StocksPage.vue       # Stock overview table
    commandes/CommandesPage.vue    # Order list by status
    commandes/CommandeEditPage.vue # Order editor (lines, franco, PDF gen, email send, calendar)
    commandes/FournisseursPage.vue # Supplier management (CRUD, email chips, delivery days)
    commandes/MercurialePage.vue   # Supplier catalog management
    commandes/StockCoverageRow.vue # Coverage + rotation indicators per product line
    reception/ReceptionPage.vue    # BL photo upload -> IA analysis -> anomaly detection
    reception/AvoirsPage.vue       # Credit note workflow + email to supplier
    recettes/RecettesPage.vue      # Recipe + ingredient list with search
    recettes/RecetteDetailPage.vue # Recipe editor (ingredients, sub-recipes, cost, allergen summary)
    recettes/IngredientDetailPage.vue  # Ingredient editor (allergens, contient, units)
    recettes/AllergeneSearchPage.vue   # Global allergen search across all recipes
    recettes/RecetteCreationIAPage.vue # Paste text -> IA extracts ingredients -> create recipe
    recettes/RentabilitePage.vue       # Multi-channel profitability calculator
    recettes/CoutMatierePage.vue       # Multi-supplier cost comparison
    inventaire/InventairePage.vue  # Inventory counting (zones, models, validation)
    previsions/PrevisionsPage.vue  # Forecasts with weather, events, confidence scores
    factures/FacturesPage.vue      # Invoice list + reconciliation + depannage detection
    reporting/ReportingPage.vue    # 5 tabs: CM, top/flop, evolution, associations, accuracy
    parametres/ParametresPage.vue  # 6 tabs: general, zones, users, calendriers, zelty, pennylane
  types/database.ts                # All TypeScript interfaces (Commande, Fournisseur, Recette, etc.)
  router/index.ts                  # Routes with auth guard + lazy loading

netlify/functions/                 # 13 Netlify Serverless Functions
  lib/gmail.js                     # Shared Gmail sending utility (Service Account + MailComposer)
  analyze-bl.js                    # BL photo -> OpenAI Vision -> structured JSON comparison
  analyze-packaging.js             # Packaging photo -> allergen + ingredient extraction
  google-calendar.js               # Create/update delivery events in Google Calendar
  send-email.js                    # Email via Gmail API (Service Account + Domain-Wide Delegation)
  parse-recette.js                 # Recipe text -> IA ingredient parsing
  sync-zelty-ca-daily.js           # Scheduled: daily CA import from Zelty closures
  backfill-zelty-ca.js             # Manual: bulk import Zelty CA for date range
  sync-zelty-photos.js             # Manual: sync product photos from Zelty
  check-alerts.js                  # Scheduled: daily notification generation
  search-product-photo.js          # Search Zelty product images
  upload-photo.js                  # Client image upload helper
  invite-user.js                   # User invitation flow (create auth user + profile)
  enrich-suppliers-pennylane.js    # Match + enrich suppliers from PennyLane data

supabase/functions/                # 6 Edge Functions (Deno)
  sync-zelty-ca/                   # Closures -> ventes_historique
  sync-zelty-stock/                # Orders -> stock decrement via recipe decomposition
  sync-meteo/                      # Open-Meteo -> meteo_daily
  sync-pennylane/                  # Supplier invoices -> factures_pennylane
  sync-gbp-hours/                  # Places API -> horaires_ouverture
  backup-drive/                    # Daily Supabase data backup to Google Drive (28 tables → JSON → Drive API v3)

supabase/migrations/               # 15 migration files (001 through 014 + timestamp)
```

## Modules principaux

### 1. Commandes (IMPLEMENTE)
- Mercuriale CRUD, recommendations aide a la commande (stock coverage, rotation)
- Franco minimum bloquant (UI empeche l'envoi)
- Statut machine : brouillon -> envoyee -> receptionnee -> controlee -> validee -> cloturee (+ avoir_en_cours)
- PDF generation brande + envoi email au fournisseur (avec BCC configurable)
- Google Calendar : creation evenement a l'envoi, mise a jour a la reception
- Auto-save brouillon IndexedDB toutes les 5s

### 2. Reception (IMPLEMENTE)
- Photo BL -> IA compare BC vs BL (OpenAI Vision, structured output)
- Detection anomalies : ecart prix, quantite manquante, produit non commande
- Workflow avoir : 4 etapes (select -> photo -> compare -> avoir -> validate)
- Email avoir au fournisseur avec photos et details

### 3. Recettes & Stocks (IMPLEMENTE)
- 3 niveaux sous-recettes, cout recursif automatique
- Variantes taille (coefficient multiplicateur) + modificateurs extra/sans
- Recherche rapide allergenes (page dediee, tous roles) + resume allergenes dans detail recette (tags rouges par allergene collecte recursivement)
- Creation rapide recette IA (coller texte -> parsing auto ingredients)
- Upload massif photos etiquettes -> extraction IA composition + allergenes batch
- Analyse rentabilite multi-canal : sur place / emporter / livraison avec simulateur prix
- Cout matiere auto via fournisseur prefere + dashboard comparatif multi-fournisseur
- Stock overview + decrementation quotidienne via Zelty sync

### 4. Inventaire (IMPLEMENTE)
- 4-5 zones de stockage configurables
- Modeles d'inventaire (complet/partiel)
- Multi-conditionnement (cartons, kg, pieces)
- Ecart theorique vs compte en temps reel
- Recalibration stock via RPC `recalibrate_stock()`

### 5. Previsions (IMPLEMENTE)
- Meteo inversee (centre commercial : pluie = +clients)
- Coefficients : meteo, evenements mobiles, rupture meteo (acclimatation), temperatures extremes non-lineaires
- **Fermetures fixes** : 1er janvier, 1er mai, 25 decembre → CA prevu = 0 EUR (fonction `isDateFermeture()`)
- **Indices saisonniers lisses** : Interpolation lineaire ancree mid-month (jour 15) entre mois adjacents, remplace les sauts en marche d'escalier
- **Superformance** : Capee a +-15%, denominateur inclut DOW + position mois pour eviter le double-comptage
- **Calibration** : Facteur x0.96 compensant le biais positif systematique (+4.5%) du stacking de coefficients
- Comparaison N-1 par jour de semaine (pas par date calendaire) — **toujours affichee** (meme sans donnees : "--"), avec tooltip montrant la date exacte comparee au survol
- Navigation semaine par semaine (fleches + bouton "Aujourd'hui") avec recalcul previsions
- Precision S-1 : `1 - avg(|CA_prevu - CA_realise| / CA_realise)` affichee en carte resumee
- Temperatures min/max affichees sur chaque carte jour
- Evolution N-1 en pourcentage sur le total semaine
- Repartition horaire CA via tickets Zelty horodates
- Score de confiance 0-100% par jour
- Sources : Open-Meteo + Zelty ventes + calendriers auto + Google Places horaires

### 6. Factures (IMPLEMENTE)
- PennyLane API : sync quotidienne via changelog polling
- Rapprochement automatique BL/factures, detection ecarts
- Detection depannage : achats sans BC (categorie "matieres premieres" PennyLane)
- Cout matiere reel vs theorique
- Detail ligne par ligne avec statut rapprochement

### 7. Reporting (IMPLEMENTE)
- 5 onglets : CM theorique vs reel, Top/Flop produits, Evolution CA, Associations produits, Precision previsions
- Cible CM configurable
- Periode semaine/mois

### 8. Parametres (IMPLEMENTE)
- 6 onglets : General, Zones de stockage, Utilisateurs, Calendriers, Zelty, PennyLane
- General : seuils alertes, emails destinataires, Google Calendar ID
- Zelty : import historique (backfill date range), sync photos, logs CRON
- PennyLane : enrichissement fournisseurs (preview -> validation -> application)
- Invitation utilisateurs (email + role)
- Sync calendriers (feries + vacances + soldes)

## Integrations -- Auth & Endpoints cles

### Google Cloud (projet phood-app-489413)
- **Service Account** (`team-phood-begles@phood-app-489413.iam.gserviceaccount.com`) + **Domain-Wide Delegation** pour Gmail + Calendar (scopes : `gmail.send`, `calendar`)
- **Places API (New)** pour horaires d'ouverture (cle API simple, pas d'OAuth). Remplace GBP API v1 dont l'acces a ete refuse par Google
- Cle JSON service account -> variable d'env Netlify `GOOGLE_SERVICE_ACCOUNT_BASE64` (base64)

### Zelty (caisse)
- Base URL : `https://api.zelty.fr/2.10/`
- Auth : `Authorization: Bearer {API_KEY}`
- Endpoints : `/orders`, `/closures`, `/products`, `/webhooks`

### PennyLane (comptabilite)
- Base URL : `https://app.pennylane.com/api/external/v2`
- Auth : `Authorization: Bearer {TOKEN_ENTREPRISE}`
- Endpoints : `/changelogs/supplier_invoices`, `/supplier_invoices/{id}`, `/supplier_invoices/{id}/invoice_lines`, `/categories`, `/suppliers`
- Rate limit : 25 req/5s, pagination curseur max 100/page

### Open-Meteo (meteo)
- Previsions : `https://api.open-meteo.com/v1/meteofrance?latitude=44.83&longitude=-0.57&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,sunshine_duration,cloud_cover_mean,weather_code`
- Historique : `https://archive-api.open-meteo.com/v1/archive?latitude=44.83&longitude=-0.57&start_date={YYYY-MM-DD}&end_date={YYYY-MM-DD}&daily=...`
- Pas de cle API requise (free tier)

### OpenAI (IA Vision)
- Modele principal : `gpt-4.1-mini` (fallback : `gpt-4.1`)
- Structured output : `response_format` JSON Schema + `strict: true`
- Images : JPEG base64, `detail: "high"`, max 2048px
- Temperature : `0.0`
- Un seul appel par photo packaging : extrait les 14 allergenes ET la liste complete des ingredients

### Supabase
- Auth : table `profiles` avec role, trigger auto `handle_new_user` sur `auth.users`. Fonction `get_my_role()` pour RLS
- Storage : 4 buckets prives (bl-photos, anomalies, pdfs, packaging)
- Realtime : Presence channels pour verrouillage commandes (`useLocking` composable)
- CRON : pg_cron -> pg_net -> Edge Functions (Deno). Service role key pour auth
- RPC : `increment_stock()`, `decrement_stock()`, `recalibrate_stock()`
- RLS enabled sur toutes les 28 tables

### Gmail API (email)
- Service Account avec Domain-Wide Delegation (scope `gmail.send`)
- Sender : `team.begles@phood-restaurant.fr`
- Module partage : `netlify/functions/lib/gmail.js` (utilise par `send-email.js` et `check-alerts.js`)
- Auto-BCC : `team.begles@phood-restaurant.fr` recoit une copie de chaque email envoye
- Emails visibles dans le dossier "Envoyes" de la boite Gmail
- Resend supprime (mars 2026)

### Calendriers automatiques
- **Jours feries** : Calcul local JS (~40 lignes). 11 fixes + mobiles (algorithme Meeus/Jones/Butcher pour Paques). Coefficient 0.7 sauf fermetures fixes (1er jan, 1er mai, 25 dec) = coefficient 0
- **Vacances scolaires** : API `data.education.gouv.fr` (Zone A = Bordeaux). 1 appel/an
- **Soldes** : Calcul local (2eme mercredi janvier, dernier mercredi juin, 4 semaines). Table d'override pour exceptions

## Specificites metier importantes
- **Centre commercial** : meteo INVERSEE (pluie = +clients, soleil = -clients)
- **Franco minimum** : BLOQUANT (impossible d'envoyer une commande en dessous)
- **Previsions** : Comparer par jour de semaine (mardi vs mardi), PAS par date calendaire
- **Commission plateforme livraison sur TTC** (pas HT) -- piege TVA, formule : `Revenu net = Prix HT - (Prix TTC x commission%)`
- **Uber Eats multi-tier** : marketplace 30%/33% (Uber One), agregateur 15%/18%, click&collect 15%/18%, preferentiel 26%/28%. Price cap +15%. Worst-case (33%) par defaut
- **Cout matiere** : toujours fournisseur prefere, auto-updated via BDL validation (pas de selection manuelle type isUsedForCost)
- **Fermetures fixes** : 1er janvier, 1er mai, 25 decembre -> toujours ferme (CA prevu = 0). Coefficient 0 dans evenements. Exclus des calculs historiques (indices, DOW, superformance)
- **Evenements mobiles** : Paques, vacances scolaires, soldes -> compares a leur equivalent N-1
- **Rupture meteo** : Coefficient d'amortissement quand transition brutale (ex : pluie 5j -> beau temps). Calibre sur historique
- **Temperatures extremes** : Coefficient non-lineaire (courbe en cloche). Base sur ecart aux normales saisonnieres
- **Depannage** : Achats hors commande detectes via PennyLane (categorie analytique "matieres premieres" + pas de BC)
- **Stock tampon** : Variable par periode (semaine lun-jeu / weekend ven-dim / vacances scolaires)
- **Notifications V1** : Dashboard + email immediat pour alertes critiques (destinataires configurables). Clochette avec badge compteur persistant (dont compositions ingredients manquantes)

## CRON Jobs (Supabase Edge Functions)
| Job | Horaire | Source | Destination |
|---|---|---|---|
| Sync CA Zelty | 06:00 | Zelty `/closures` | `ventes_historique` |
| Sync factures PennyLane | 06:30 | PennyLane `/changelogs/supplier_invoices` | `factures_pennylane` |
| Previsions meteo | 07:00 | Open-Meteo `/v1/meteofrance` | `meteo_daily` |
| Sync horaires Places | 07:30 | Places API `/v1/places/{id}` | `horaires_ouverture` |
| Backup Google Drive | quotidien | Supabase data (28 tables JSON) | Google Drive |
| Check alerts | quotidien | Internal | `notifications` |

Architecture : `pg_cron` -> `pg_net` (HTTP call) -> Edge Function (Deno). Monitoring via table `cron_logs`.

### Deploiement des Edge Functions
Les 6 Edge Functions doivent etre deployees via le CLI Supabase :
```bash
npx supabase login --token <ACCESS_TOKEN>
npx supabase link --project-ref pfcvtpavwjchwdarhixc
npx supabase functions deploy sync-zelty-ca
npx supabase functions deploy sync-pennylane
npx supabase functions deploy sync-meteo
npx supabase functions deploy sync-gbp-hours
npx supabase functions deploy sync-zelty-stock
npx supabase functions deploy backup-drive
```

Secrets requis (en plus de SUPABASE_URL et SUPABASE_SERVICE_ROLE_KEY qui sont auto-injectes) :
```bash
npx supabase secrets set PENNYLANE_API_TOKEN="..."
npx supabase secrets set ZELTY_API_KEY="..."
npx supabase secrets set GOOGLE_SERVICE_ACCOUNT_BASE64="..."
npx supabase secrets set GOOGLE_PLACES_API_KEY="..."
npx supabase secrets set PHOOD_BEGLES_PLACE_ID="ChIJRRTmT5gmVQ0Rk4sBmRERCLI"
npx supabase secrets set GOOGLE_DRIVE_BACKUP_FOLDER_ID="..."  # optionnel
```

## 7.5 Aide a la commande (IMPLEMENTE)

Lors de la passation de commande, le systeme affiche pour chaque produit (composant `StockCoverageRow.vue`) :

```
+-----------------------------------------------------------+
| Poulet emince (Transgourmet)                              |
|                                                           |
| Stock actuel : 12 kg                                      |
| Stock tampon : 5 kg                                       |
| Prevision conso (3 jours) : 18 kg                         |
| ----------------------------------------                  |
| Recommandation : 11 kg         [  -  ] [ 11 ] [  +  ]    |
|                                                           |
| Stock couvre jusqu'au : sam. 8 mars (3.8 jours)           |
| Rotation : ~1 jour/carton (5 kg)                          |
|                                                           |
| Derniere commande : 24/02 - 15 kg - 4.50 EUR/kg          |
| Prix actuel : 4.65 EUR/kg (+3.3%)                         |
+-----------------------------------------------------------+
```

**Indicateurs de couverture et rotation :**

**Stock couvre jusqu'au** -- Date calculee automatiquement :

```
jours_couverture = (stock_actuel + quantite_commandee - stock_tampon) / consommation_moyenne_journaliere
date_couverture = date_livraison_prevue + jours_couverture
```

- La consommation moyenne est calculee sur les 4 dernieres semaines (meme jour de semaine)
- La quantite commandee est celle affichee dans le champ (recommandation ou ajustee manuellement)
- **Mise a jour en temps reel** : quand l'operateur modifie la quantite avec `[+]` / `[-]`, la date de couverture se recalcule instantanement
- Si la date de couverture depasse la prochaine livraison possible du meme fournisseur -> affichage vert. Sinon -> orange

**Rotation** -- Duree de vie d'un conditionnement de commande :

```
duree_rotation = conditionnement_en_unite_stock / consommation_moyenne_journaliere
```

**Icones de rotation :**
| Icone | Duree | Signification |
|---|---|---|
| Rapide | < 1 semaine | Rotation rapide -- produit a commander frequemment |
| Moyenne | 1 semaine - 2 mois | Rotation moyenne |
| Lente | > 2 mois | Rotation lente -- attention au sur-stock |

> **Note :** La rotation est purement informative en V1. Le croisement avec la DLC/DDM (`dlc_ddm_jours` en mercuriale) pour alerter sur un risque de gaspillage est prevu en V2 dans le cadre du suivi DLC complet.

## Offline & PWA (IMPLEMENTE)
- **IndexedDB via Dexie** : 23 tables mirroring Supabase schema
- **Service Worker** : Configure via `vite-plugin-pwa`, precache ~80 entries
- **Sync queue** : Mutations hors-ligne stockees dans IndexedDB, auto-flush on reconnect (`sync-queue.ts`)
- **Network-first caching** : Supabase API calls cached 30s avec limite 200 entries
- **Manifest** : theme color #E85D2C, icons 192x512px, standalone mode
- **Indicateur sync** : Badge visuel dans le layout quand hors-ligne ou sync en cours

## Donnees existantes
- inpulse export : `/Projet/PhoodApp/inpulse_export_phood_actifs.json` (6.85 MB, 383 ingredients actifs, 209 avec fournisseurs)
- Migration `002_seed_inpulse_data.sql` : import initial fait
- Migration `010_deactivate_inpulse_orphans.sql` : nettoyage orphelins fait
- Recettes : `/RECETTES/` (Google Drive)
- Fournisseurs : `/Fournisseurs/` (Google Drive)

## Statut implementation V1

### IMPLEMENTE ET FONCTIONNEL
| Module | Completude | Fichiers cles |
|---|---|---|
| Auth & RLS | 100% | `useAuth.ts`, migrations 001/006 |
| Commandes | 95% | `CommandeEditPage.vue`, `commandes.ts`, `pdf-commande.ts` |
| Reception | 100% | `ReceptionPage.vue`, `AvoirsPage.vue`, `analyze-bl.js` |
| Recettes | 98% | `RecetteDetailPage.vue`, `recettes.ts`, `AllergeneSearchPage.vue` |
| Stocks | 95% | `StocksPage.vue`, `stocks.ts`, `sync-zelty-stock/` |
| Inventaire | 100% | `InventairePage.vue`, `inventaire.ts` |
| Previsions | 95% | `PrevisionsPage.vue`, `previsions.ts`, `sync-meteo/` |
| Factures | 95% | `FacturesPage.vue`, `factures.ts`, `sync-pennylane/` |
| Reporting | 95% | `ReportingPage.vue`, `reporting.ts` |
| Fournisseurs | 100% | `FournisseursPage.vue`, `fournisseurs.ts` (tous champs CDC presents) |
| Parametres | 100% | `ParametresPage.vue` (6 onglets, backfill Zelty, PennyLane enrich) |
| Notifications | 90% | `NotificationPanel.vue`, `notifications.ts`, `check-alerts.js` |
| Offline/PWA | 100% | `dexie.ts`, `sync-queue.ts`, `useOffline.ts` |
| Integrations | 95% | 13 Netlify Functions + 6 Edge Functions |

### RESTE A FAIRE (V1.1 post-launch)
- **Recommandation auto quantite commande** : Le calcul de couverture existe, mais le champ "Recommandation" n'est pas pre-rempli automatiquement
- **Webhook Zelty temps reel** : Stock decremente en daily sync; webhook pour temps reel pas encore configure
- **Fine-tuning coefficients meteo** : Coefficients implementes mais necessitent calibrage sur 2-3 semaines de donnees reelles
- **Zelty product import** : Produits/variantes pas auto-importes depuis Zelty (creation manuelle requise)
- **Export CSV/PDF factures** : Vue detail existe, export fichier pas encore fait
- **Conflit sync offline** : Last-write-wins (rare en V1, workflow operateur)
