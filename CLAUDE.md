# PhoodApp — Instructions pour Claude Code

## Contexte
Application web sur-mesure pour **Phood Restaurant** (Bègles, centre commercial) remplaçant inpulse.ai.
Gestion des commandes fournisseurs, recettes, stocks, prévisions de ventes, factures, rentabilité multi-canal.

## Cahier des charges
**LIRE EN PREMIER** : `CAHIER_DES_CHARGES.md` (dans ce même dossier)
En cours de finalisation. Contient TOUTES les spécifications fonctionnelles, techniques, UX et le modèle de données.

## Stack technique
| Composant | Technologie | Détails |
|---|---|---|
| Frontend | Vue.js 3 (Composition API) + Vite | PWA avec offline (IndexedDB via Dexie.js + Service Worker) |
| Hébergement | Netlify | CDN statique + Serverless Functions (OpenAI, Gmail) |
| Base de données | Supabase (PostgreSQL) | Données structurées, RLS par rôle via `get_my_role()`, pg_cron + pg_net |
| Auth | Supabase Auth | Email/password + Google OAuth Workspace. Table `profiles` liée à `auth.users` |
| Storage | Supabase Storage | 4 buckets privés (bl-photos, anomalies, pdfs, packaging). Compression client-side max 2048px |
| Realtime | Supabase Realtime | Presence channels pour verrouillage commandes (heartbeat 30s, timeout 15 min) |
| CRON | Supabase Edge Functions (Deno) | pg_cron → pg_net → Edge Functions. 4 jobs quotidiens (06:00-07:30) |
| IA | OpenAI API (GPT-4.1-mini) | Lecture BL, détection allergènes + extraction ingrédients (`contient`), extraction prix, parsing recettes. Structured output JSON strict. Fallback : GPT-4.1 standard |
| Caisse | Zelty API v2.10 | Bearer token. Import CA historique (`/orders`, `/closures`) + sync quotidien |
| Email | Gmail API v1 | Service Account + Domain-Wide Delegation. Envoi via `team.begles@phood-restaurant.fr`. MIME via nodemailer/MailComposer |
| Comptabilité | PennyLane API v2 | Token entreprise lecture seule. Changelog polling quotidien. Détection dépannage + rapprochement factures/BL + coût réel |
| Calendrier | Google Calendar API v3 | Même service account que Gmail. RRULE RFC 5545, modification instances, extendedProperties.private |
| Horaires | Google Places API (New) | Clé API simple. Place ID Bègles : `ChIJRRTmT5gmVQ0Rk4sBmRERCLI`. Remplace GBP API (accès refusé par Google) |
| Météo | Open-Meteo | Free tier sans clé API. Modèles Météo-France AROME 1.5km + ARPEGE. Coordonnées : lat=44.83, lon=-0.57 |
| PDF | jsPDF + jspdf-autotable | Génération client-side (~526 KB bundle). Bons de commande brandés Phood. Fonctionne hors-ligne |
| Backup | Google Drive API | Sauvegarde automatique quotidienne des données Supabase |
| Calendriers auto | Calcul local + API data.gouv.fr | Jours fériés (algo Pâques Meeus), vacances scolaires Zone A, soldes (calcul + override) |

> **Combo (planning)** : Intégration annulée — API Partner non accessible avec le plan actuel (plan Time, pas Pro). Répartition horaire du CA calculée nativement via tickets Zelty horodatés (section 7.6 du CDC).

## Architecture données
```
Ingrédient Fournisseur (mercuriale, SKU, conditionnements, prix)
       ↓ (N:1)
Ingrédient Restaurant (ce qu'on utilise en cuisine, cout_unitaire auto, contient, allergenes)
       ↓ (1:N)
Recette / Produit Caisse (synchro Zelty, variantes taille, modificateurs extra/sans, prix_vente multi-canal)
```
- Sous-recettes imbriquées jusqu'à **3 niveaux** (sauce → marinade → préparation → plat)
- Sous-recettes = PAS de stock propre, toujours décrémentation récursive aux ingrédients de base
- Produits sans recette (boissons, snacks) = lien direct ingrédient fournisseur
- Champ `contient` sur ingrédients achetés tout prêts (sauces, préparations) : liste libre de sous-ingrédients pour la recherche allergènes

## Conventions
- **Langue** : Français pour l'UI, anglais pour le code (noms de variables, fonctions, commentaires)
- **iPad-first** : Boutons 48-56px, fonts 18px+, navigation bottom bar, clavier numérique natif
- **Auto-save** : IndexedDB toutes les 5 secondes, sync Supabase quand online
- **Numérotation commandes** : `BC{AAAAMMJJ}-{NNN}` (ex: BC20260303-001)
- **Rôles V1** : Admin (full), Manager + Opérateur (commandes + réception + allergènes uniquement). Permissions extensibles plus tard

## Modules principaux
1. **Commandes** — Mercuriale, recommandations auto, franco bloquant, calendrier livraison, Google Calendar
2. **Réception** — Photo BL → IA compare BC vs BL, anomalies, demande d'avoir, relance auto Gmail
3. **Recettes & Stocks** — 3 niveaux, sous-recettes, variantes taille, extras/sans, décrémentation Zelty
   - Recherche rapide allergènes (tous rôles, usage comptoir client, inclut champ `contient`)
   - Création rapide recette IA (coller texte → parsing auto ingrédients)
   - Upload massif photos étiquettes → extraction IA composition + allergènes batch
   - Analyse rentabilité multi-canal : sur place / emporter / livraison avec simulateur prix
   - Coût matière auto via fournisseur préféré + dashboard comparatif multi-fournisseur
4. **Inventaire** — 4-5 zones de stockage, modèles d'inventaire (complet/partiel), multi-conditionnement
5. **Prévisions** — Météo inversée (CC), événements mobiles, rupture météo (acclimatation), températures extrêmes non-linéaires, comparaison N-1, répartition horaire CA (Zelty)
6. **Factures** — PennyLane API, rapprochement BL, détection achats dépannage (sans BC), coût matière réel vs théorique
7. **Reporting** — CM théorique vs réel, Top/Flop, associations produits caisse, précision S-1

## Intégrations — Auth & Endpoints clés

### Google Cloud (un seul projet)
- **Service Account + Domain-Wide Delegation** pour Gmail + Calendar (scopes : `gmail.send`, `calendar`)
- **Places API (New)** pour horaires d'ouverture (clé API simple, pas d'OAuth). Remplace GBP API v1 dont l'accès a été refusé par Google
- Clé JSON service account → variable d'env Netlify (base64)

### Zelty (caisse)
- Base URL : `https://api.zelty.fr/2.10/`
- Auth : `Authorization: Bearer {API_KEY}`
- Endpoints : `/orders`, `/closures`, `/products`, `/webhooks`
- Webhook existant : `/Projet/Zelty Webhook/`

### PennyLane (comptabilité)
- Base URL : `https://app.pennylane.com/api/external/v2`
- Auth : `Authorization: Bearer {TOKEN_ENTREPRISE}`
- Endpoints : `/changelogs/supplier_invoices`, `/supplier_invoices/{id}`, `/supplier_invoices/{id}/invoice_lines`, `/categories`, `/suppliers`
- Rate limit : 25 req/5s, pagination curseur max 100/page

### Open-Meteo (météo)
- Prévisions : `https://api.open-meteo.com/v1/meteofrance?latitude=44.83&longitude=-0.57&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,sunshine_duration,cloud_cover_mean,weather_code`
- Historique : `https://archive-api.open-meteo.com/v1/archive?latitude=44.83&longitude=-0.57&start_date={YYYY-MM-DD}&end_date={YYYY-MM-DD}&daily=...`
- Pas de clé API requise (free tier)

### OpenAI (IA Vision)
- Modèle principal : `gpt-4.1-mini` (fallback : `gpt-4.1`)
- Structured output : `response_format` JSON Schema + `strict: true`
- Images : JPEG base64, `detail: "high"`, max 2048px
- Température : `0.0`
- Un seul appel par photo packaging : extrait les 14 allergènes ET la liste complète des ingrédients

### Supabase
- Auth : table `profiles` avec rôle, trigger auto sur `auth.users`. Fonction `get_my_role()` pour RLS
- Storage : 4 buckets privés (bl-photos, anomalies, pdfs, packaging)
- Realtime : Presence channels pour verrouillage commandes
- CRON : pg_cron → pg_net → Edge Functions (Deno). Service role key pour auth

### Calendriers automatiques
- **Jours fériés** : Calcul local JS (~40 lignes). 11 fixes + mobiles (algorithme Meeus/Jones/Butcher pour Pâques)
- **Vacances scolaires** : API `data.education.gouv.fr` (Zone A = Bordeaux). 1 appel/an
- **Soldes** : Calcul local (2ème mercredi janvier, dernier mercredi juin, 4 semaines). Table d'override pour exceptions

## Spécificités métier importantes
- **Centre commercial** : météo INVERSÉE (pluie = +clients, soleil = -clients)
- **Franco minimum** : BLOQUANT (impossible d'envoyer une commande en dessous)
- **Prévisions** : Comparer par jour de semaine (mardi vs mardi), PAS par date calendaire
- **Commission plateforme livraison sur TTC** (pas HT) — piège TVA, formule : `Revenu net = Prix HT − (Prix TTC × commission%)`
- **Uber Eats multi-tier** : marketplace 30%/33% (Uber One), agrégateur 15%/18%, click&collect 15%/18%, préférentiel 26%/28%. Price cap +15%. Worst-case (33%) par défaut
- **Coût matière** : toujours fournisseur préféré, auto-updated via BDL validation (pas de sélection manuelle type isUsedForCost)
- **Événements mobiles** : Pâques, vacances scolaires, soldes → comparés à leur équivalent N-1
- **Rupture météo** : Coefficient d'amortissement quand transition brutale (ex : pluie 5j → beau temps). Calibré sur historique
- **Températures extrêmes** : Coefficient non-linéaire (courbe en cloche). Basé sur écart aux normales saisonnières
- **Dépannage** : Achats hors commande détectés via PennyLane (catégorie analytique "matières premières" + pas de BC)
- **Stock tampon** : Variable par période (semaine lun-jeu / weekend ven-dim / vacances scolaires)
- **Notifications V1** : Dashboard + email immédiat pour alertes critiques (destinataires configurables). Clochette 🔔 avec badge compteur persistant (dont compositions ingrédients manquantes)

## CRON Jobs (Supabase Edge Functions)
| Job | Horaire | Source | Destination |
|---|---|---|---|
| Sync CA Zelty | 06:00 | Zelty `/closures` | `ventes_historique` |
| Sync factures PennyLane | 06:30 | PennyLane `/changelogs/supplier_invoices` | `factures_pennylane` |
| Prévisions météo | 07:00 | Open-Meteo `/v1/meteofrance` | `meteo_daily` |
| Sync horaires Places | 07:30 | Places API `/v1/places/{id}` | `horaires_ouverture` |

Architecture : `pg_cron` → `pg_net` (HTTP call) → Edge Function (Deno). Monitoring via table `cron_logs`.

## 7.5 Aide à la commande

Lors de la passation de commande, le système affiche pour chaque produit :

```
┌─────────────────────────────────────────────────────────┐
│ Poulet émincé (Transgourmet)                            │
│                                                         │
│ Stock actuel : 12 kg                                    │
│ Stock tampon : 5 kg                                     │
│ Prévision conso (3 jours) : 18 kg                       │
│ ──────────────────────────────                          │
│ Recommandation : 11 kg         [  -  ] [ 11 ] [  +  ]  │
│                                                         │
│ 📦 Stock couvre jusqu'au : sam. 8 mars (3.8 jours)      │
│ 🔄 Rotation : ~1 jour/carton (5 kg) 🚀                 │
│                                                         │
│ Dernière commande : 24/02 - 15 kg - 4.50€/kg           │
│ Prix actuel : 4.65€/kg (+3.3%)                          │
└─────────────────────────────────────────────────────────┘
```

**Indicateurs de couverture et rotation :**

📦 **Stock couvre jusqu'au** — Date calculée automatiquement :

```
jours_couverture = (stock_actuel + quantite_commandee − stock_tampon) / consommation_moyenne_journaliere
date_couverture = date_livraison_prevue + jours_couverture
```

- La consommation moyenne est calculée sur les 4 dernières semaines (même jour de semaine)
- La quantité commandée est celle affichée dans le champ (recommandation ou ajustée manuellement)
- **Mise à jour en temps réel** : quand l'opérateur modifie la quantité avec `[+]` / `[-]`, la date de couverture se recalcule instantanément
- Si la date de couverture dépasse la prochaine livraison possible du même fournisseur → affichage vert. Sinon → orange

🔄 **Rotation** — Durée de vie d'un conditionnement de commande :

```
duree_rotation = conditionnement_en_unite_stock / consommation_moyenne_journaliere
```

Exemples types :
| Produit | Conditionnement | Conso/jour | Rotation | Icône |
|---|---|---|---|---|
| Poulet émincé (5 kg) | 5 kg | 6 kg/j | < 1 jour | 🚀 |
| Huile de sésame (5L) | 5 L | 0.15 L/j | ~1 mois | 🔄 |
| Sauce soja (5L) | 5 L | 0.03 L/j | ~6 mois | 🐌 |
| Épice citronnelle (500g) | 500 g | 5 g/j | ~3 mois | 🐌 |

**Icônes de rotation :**
| Icône | Durée | Signification |
|---|---|---|
| 🚀 | < 1 semaine | Rotation rapide — produit à commander fréquemment |
| 🔄 | 1 semaine - 2 mois | Rotation moyenne |
| 🐌 | > 2 mois | Rotation lente — attention au sur-stock |

> **Note :** La rotation est purement informative en V1. Le croisement avec la DLC/DDM (`dlc_ddm_jours` en mercuriale) pour alerter sur un risque de gaspillage est prévu en V2 dans le cadre du suivi DLC complet.

## Données existantes
- inpulse export : `/Projet/PhoodApp/inpulse_export_phood_actifs.json` (6.85 MB, 383 ingrédients actifs, 209 avec fournisseurs)
- Recettes : `/RECETTES/` (Google Drive)
- Fournisseurs : `/Fournisseurs/` (Google Drive)
- Webhook Zelty : `/Projet/Zelty Webhook/` (Google Drive)
- Automations existantes : `/Projet/Automate/` (Google Drive)
