# Cahier des Charges - Phood App
## Application de gestion des commandes, recettes et prévision des ventes

**Version:** 1.2 - Affiné avec analyse UX inpulse
**Date:** 04/03/2026
**Auteur:** Benjamin Fetu / Phood Restaurant
**Site:** Bègles (mono-site)
**Objectif lancement V1:** 2 semaines (~17/03/2026)
**Période de transition:** 1-2 mois en parallèle avec inpulse.ai

---

## Table des matières

1. [Contexte et objectifs](#1-contexte-et-objectifs)
2. [Architecture technique](#2-architecture-technique)
3. [Module 1 : Passation de commandes](#3-module-1--passation-de-commandes)
4. [Module 2 : Réception et contrôle](#4-module-2--réception-et-contrôle)
5. [Module 3 : Gestion des recettes et stocks](#5-module-3--gestion-des-recettes-et-stocks)
6. [Module 4 : Inventaire physique](#6-module-4--inventaire-physique)
7. [Module 5 : Prévision des ventes et aide à la commande](#7-module-5--prévision-des-ventes-et-aide-à-la-commande)
   - 7b. [Module 5b : Rapprochement des factures fournisseurs](#7b-module-5b--rapprochement-des-factures-fournisseurs)
8. [Module 6 : Reporting (V1 essentiel)](#8-module-6--reporting-v1-essentiel)
9. [Gestion des utilisateurs et droits](#9-gestion-des-utilisateurs-et-droits)
10. [Contraintes UX / iPad](#10-contraintes-ux--ipad)
11. [Intégrations externes](#11-intégrations-externes)
12. [Sauvegarde et sécurité](#12-sauvegarde-et-sécurité)
13. [Fonctionnalités V2+ (hors scope V1)](#13-fonctionnalités-v2-hors-scope-v1)
14. [Modèle de données](#14-modèle-de-données)
15. [Questions ouvertes](#15-questions-ouvertes)

---

## 1. Contexte et objectifs

### 1.1 Contexte
Phood Restaurant (Bègles) utilise actuellement **inpulse.ai** pour la gestion des commandes fournisseurs, des recettes et la prévision des ventes. Le logiciel présente plusieurs limitations :
- Interface non optimisée pour tablette (boutons trop petits, champs de date inadaptés)
- Pas d'auto-save (risque de perte de données)
- Prévision des ventes insuffisante (ne prend pas assez en compte les spécificités locales, notamment la météo)
- Coût récurrent du SaaS

### 1.2 Objectifs
Développer une application web sur-mesure qui :
- **Remplace intégralement inpulse.ai** pour le site de Bègles
- **Optimise l'expérience iPad** pour les opérations en cuisine/réception
- **Améliore la prévision des ventes** en intégrant des données locales (météo, événements, facteurs custom)
- **Automatise le contrôle à réception** via IA (lecture de bons de livraison)
- **Garantit la fiabilité** avec auto-save et mode hors-ligne (PWA)
- **Minimise les coûts** grâce à une architecture serverless (Netlify, Supabase, Google Drive)

### 1.3 Périmètre V1
- Mono-site : Bègles uniquement
- 3 rôles utilisateurs : Admin, Manager, Opérateur
- Pas de module pertes/gaspillage détaillé (prévu V2)
- Pas de suivi DLC (prévu V2)
- Pas de notifications push (prévu V2)
- Email immédiat à l'admin pour les **alertes critiques** uniquement (prix à valider, avoir sans réponse, nouveau produit Zelty non associé, facture dépannage)
- Reporting essentiel uniquement

---

## 2. Architecture technique

### 2.1 Stack technologique

| Composant | Technologie | Rôle |
|---|---|---|
| **Frontend** | Vue.js 3 (Composition API) + Vite | Application web PWA, IndexedDB offline via Dexie.js |
| **Hébergement** | Netlify | CDN statique + Serverless Functions (OpenAI, Gmail) |
| **Base de données** | Supabase (PostgreSQL) | Données structurées, RLS par rôle, pg_cron + pg_net |
| **Auth** | Supabase Auth | Email/password + Google OAuth Workspace, 3 rôles (admin/manager/operator) |
| **Storage** | Supabase Storage | Photos BL, packaging, anomalies, PDFs générés. Buckets privés + RLS |
| **Realtime** | Supabase Realtime | Verrouillage commandes (Presence channels) |
| **CRON** | Supabase Edge Functions (Deno) | pg_cron → pg_net → Edge Functions. 4 jobs quotidiens (Zelty, PennyLane, météo, GBP) |
| **Email** | Gmail API v1 | Service Account + DWD. Envoi commandes, avoirs, alertes via `team.begles@phood-restaurant.fr` |
| **IA** | OpenAI API (GPT-4.1-mini) | Lecture BL, détection allergènes, écarts prix. Structured output JSON strict |
| **Caisse** | Zelty API v2.10 | Import CA historique + sync quotidien + décrémentation stocks |
| **Météo** | Open-Meteo | Modèles AROME/ARPEGE, prévisions J+16 + historique depuis 1940. Free tier sans clé API |
| **Comptabilité** | PennyLane API v2 | Détection dépannage + rapprochement factures/BL + coût matière réel |
| **Calendrier** | Google Calendar API v3 | Événements récurrents commande (même service account que Gmail) |
| **Horaires** | Google Business Profile API v1 | OAuth 2.0, approbation requise. Fallback : saisie manuelle |
| **PDF** | jsPDF + jspdf-autotable | Génération client-side (~526 KB bundle). Bons de commande brandés Phood |
| **Backup** | Google Drive API | Sauvegarde automatique des données Supabase |
| **Calendriers auto** | Calcul local + API data.gouv.fr | Jours fériés (algo Pâques), vacances scolaires (Zone A), soldes |

### 2.2 Architecture globale

```
┌─────────────────────────────────────────────────────────┐
│                    NETLIFY (Hosting)                     │
│  ┌───────────────────────────────────────────────────┐  │
│  │  Vue.js 3 PWA (Vite + Vue Router + Pinia)         │  │
│  │  - IndexedDB offline (Dexie.js)                   │  │
│  │  - Service Worker (caching)                       │  │
│  │  - jsPDF (génération PDF client-side)             │  │
│  │  - Compression images client-side (Canvas API)    │  │
│  └───────────────┬───────────────────────────────────┘  │
│                  │                                       │
│  ┌───────────────┴───────────────────────────────────┐  │
│  │  Netlify Functions (serverless)                   │  │
│  │  - OpenAI API (lecture BL, allergènes)            │  │
│  │  - Gmail API (envoi commandes, avoirs, alertes)   │  │
│  └───────────────────────────────────────────────────┘  │
└──────────────────┬──────────────────────────────────────┘
                   │ HTTPS (PostgREST + Realtime WS)
┌──────────────────┴──────────────────────────────────────┐
│                   SUPABASE                              │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Auth       │  │  PostgreSQL  │  │  Storage     │  │
│  │  Email/pwd  │  │  ~20 tables  │  │  Photos BL   │  │
│  │  Google     │  │  RLS/rôles   │  │  PDFs        │  │
│  │  OAuth      │  │  pg_cron     │  │  Packaging   │  │
│  └─────────────┘  └──────────────┘  └──────────────┘  │
│  ┌─────────────┐  ┌──────────────┐                     │
│  │  Realtime   │  │  Edge Fns    │ ← CRON quotidiens   │
│  │  Presence   │  │  Zelty sync  │                     │
│  │  (locks)    │  │  PennyLane   │                     │
│  │             │  │  Open-Meteo  │                     │
│  │             │  │  GBP sync    │                     │
│  └─────────────┘  └──────────────┘                     │
└──────────────────┬──────────────────────────────────────┘
                   │ APIs externes
    ┌──────────────┴──────────────────────────────────────┐
    │  Zelty · PennyLane · Open-Meteo                    │
    │  Google Calendar · GBP · OpenAI · Gmail             │
    └─────────────────────────────────────────────────────┘
```

### 2.3 Mode hors-ligne (PWA)

L'application DOIT fonctionner sans connexion internet pour les opérations critiques :

**Fonctionnel hors-ligne :**
- Consultation de la mercuriale et des recettes
- Saisie d'une commande (enregistrée localement)
- Saisie d'un contrôle à réception (photos stockées localement)
- Saisie d'un inventaire physique
- Consultation des stocks théoriques

**Nécessite une connexion :**
- Envoi de commande par email au fournisseur
- Synchronisation avec Zelty
- Appel IA pour lecture de BL
- Prévision des ventes (appel API météo)
- Sauvegarde sur Google Drive

**Synchronisation :**
- Auto-sync dès que la connexion revient
- File d'attente des actions en attente (queue)
- Indicateur visuel de l'état de synchronisation (en ligne/hors-ligne/sync en cours)
- Résolution de conflits : dernière modification gagne + alerte si conflit

### 2.4 Auto-save

**Règle absolue : aucune donnée saisie ne doit être perdue.**

- Sauvegarde automatique dans IndexedDB toutes les 5 secondes pendant la saisie
- Sauvegarde vers Supabase dès que possible (online)
- Indicateur visuel : "Sauvegardé" / "Sauvegarde en cours..." / "Non sauvegardé (hors-ligne)"
- Récupération automatique en cas de crash/fermeture du navigateur

### 2.5 Architecture Supabase détaillée

**Free tier** (suffisant pour 2-3 ans au volume Phood) :
- 500 MB base de données PostgreSQL (volume estimé < 50 MB/an)
- 1 GB stockage fichiers (photos BL, PDFs)
- 200 connexions Realtime simultanées
- 500 000 Edge Function invocations/mois
- 2 GB bandwidth/mois

**Authentification (Supabase Auth) :**
- Méthode principale : email + mot de passe
- Option : Google OAuth via Google Workspace Phood (`@phood-restaurant.fr`)
- Table `profiles` liée automatiquement à `auth.users` via trigger `on_auth_user_created`
- Champ `role` dans `profiles` : `admin`, `manager`, `operator`
- Session JWT automatique, refresh transparent côté client (`@supabase/supabase-js`)

**Row Level Security (RLS) :**
```sql
-- Fonction helper pour récupérer le rôle de l'utilisateur connecté
CREATE FUNCTION get_my_role() RETURNS text AS $$
  SELECT role FROM profiles WHERE id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Exemple de politique RLS sur la table commandes
CREATE POLICY "Tous les rôles peuvent lire les commandes"
  ON commandes FOR SELECT USING (true);

CREATE POLICY "Seuls admin et manager peuvent valider"
  ON commandes FOR UPDATE USING (
    get_my_role() IN ('admin', 'manager')
    OR (get_my_role() = 'operator' AND statut = 'brouillon')
  );
```

Chaque table a ses politiques RLS activées selon la matrice de droits (section 9.1).

**Realtime — Verrouillage des commandes (Presence) :**
```
Canal : "commande:{commande_id}"
→ Presence.track({ user_id, user_name, editing_since })
→ Les autres clients reçoivent l'état et affichent "En cours de modification par {user_name}"
→ Présence auto-nettoyée si déconnexion (heartbeat 30s)
→ Timeout d'inactivité : 15 min (release automatique du verrou)
```

**Storage — Buckets :**

| Bucket | Accès | Contenu | Rétention |
|---|---|---|---|
| `bl-photos` | Privé (RLS) | Photos de bons de livraison (JPEG compressé, max 2048px) | Illimité |
| `anomalies` | Privé (RLS) | Photos d'anomalies à réception | Illimité |
| `pdfs` | Privé (RLS) | Bons de commande PDF générés | Illimité |
| `packaging` | Privé (RLS) | Photos de packaging/conditionnement produits | Illimité |

Compression client-side avant upload : Canvas API → JPEG qualité 0.8, redimensionnement max 2048px.

### 2.6 CRON Jobs (Supabase Edge Functions)

Architecture : `pg_cron` → `pg_net` (HTTP call) → Edge Function (Deno)

| Job | Fréquence | Horaire | Edge Function | Source API | Table destination | Logique |
|---|---|---|---|---|---|---|
| **Sync CA Zelty** | Quotidien | 06:00 | `sync-zelty-ca` | Zelty `/closures` | `ventes_historique` | Récupère la clôture de veille (CA TTC, nb tickets, nb couverts). Skip si déjà importé |
| **Sync factures PennyLane** | Quotidien | 06:30 | `sync-pennylane` | PennyLane `/changelogs/supplier_invoices` | `factures_pennylane` | Changelog polling : récupère les factures créées/modifiées depuis dernière sync. Détection dépannage automatique |
| **Prévisions météo** | Quotidien | 07:00 | `sync-meteo` | Open-Meteo `/v1/meteofrance` | `meteo_daily` | Récupère prévisions J à J+16. Upsert sur les jours existants (mise à jour progressive) |
| **Sync horaires GBP** | Quotidien | 07:30 | `sync-gbp-hours` | GBP `/locations/{id}` | `horaires_ouverture` | Récupère regularHours + specialHours. Compare et met à jour si changement. Fallback silencieux si API indisponible |

**Configuration pg_cron :**
```sql
-- Planification des 4 jobs quotidiens
SELECT cron.schedule('sync-zelty-ca', '0 6 * * *',
  $$SELECT net.http_post(
    url := 'https://{project}.supabase.co/functions/v1/sync-zelty-ca',
    headers := '{"Authorization": "Bearer {service_role_key}"}'::jsonb
  )$$
);
-- Idem pour les 4 autres jobs avec horaires décalés de 30 min
```

**Monitoring :** Chaque job enregistre son exécution dans une table `cron_logs` (timestamp, statut, durée, erreurs). Dashboard admin pour visualiser l'historique des exécutions.

---

## 3. Module 1 : Passation de commandes

### 3.1 Mercuriale

La mercuriale est le catalogue des produits commandables par fournisseur.

**Données par référence produit :**

| Champ | Type | Description |
|---|---|---|
| `ref_fournisseur` | string | Référence produit chez le fournisseur (SKU) |
| `designation` | string | Nom du produit |
| `fournisseur_id` | string | Lien vers le profil fournisseur |
| `unite_commande` | string | Unité de commande (kg, pièce, carton, litre...) |
| `conditionnements` | array | Liste des conditionnements possibles avec conversion (voir ci-dessous) |
| `prix_unitaire_ht` | number | Prix HT actuel par unité de commande |
| `prix_futur` | object | Prix à venir si connu : {prix: number, date_effet: date} (optionnel) |
| `type_prix` | string | "standard" (variable) / "trimestriel" (fixé au trimestre) / "annuel" (contrat annuel) |
| `date_fin_prix` | date | Date de fin de validité du prix contractuel (si trimestriel ou annuel) |
| `historique_prix` | array | Historique des changements de prix [{date, prix_ancien, prix_nouveau, source, valide_par}] |
| `tva` | number | Taux de TVA applicable (%) |
| `prix_modifiable_reception` | boolean | Si `true`, le prix peut être modifié lors du contrôle à réception (produits à prix variable comme le frais) |
| `dlc_ddm_jours` | number | Durée de vie du produit en jours (DLC/DDM) - informatif, pas de suivi DLC en V1 |
| `pertes_pct` | number | Pourcentage de pertes à la préparation (ex: 5 = 5% de perte). Utilisé pour ajuster les recommandations de commande |
| `unite_stock` | string | Unité de stockage (peut différer de l'unité de commande) |
| `coefficient_conversion` | number | Ratio unité commande → unité stock (ex: 1 carton = 3 kg → coeff = 3) |
| `nombre_portions` | number | Nombre de portions/pièces par unité (ex: sachet de 50 nems → 50). Utile pour la conversion vers les recettes qui utilisent des unités (pièces) |
| `ingredient_restaurant_id` | string | Lien vers l'ingrédient restaurant associé |
| `stock_tampon` | object | Stock de sécurité variable par période : {semaine: number, weekend: number, vacances: number}. Semaine = lun-jeu, Weekend = ven-dim, Vacances = vacances scolaires zone |
| `photo_url` | string | Photo du produit (optionnel) |
| `actif` | boolean | Référence active ou archivée |
| `categorie` | string | Catégorie produit (légumes, viandes, sauces...) |
| `notes` | string | Commentaires libres |
| `notes_internes` | string | Notes internes visibles par l'équipe (non envoyées au fournisseur) |

**Structure d'un conditionnement :**
```json
{
  "conditionnements": [
    {
      "nom": "Unité",
      "unite_commande": "unité",
      "contenance": 1,
      "unite_contenance": "unité",
      "prix_unitaire_ht": null,
      "minimum_commande": 1,
      "maximum": null,
      "utilise_commande": false,
      "utilise_inventaire": true
    },
    {
      "nom": "Sac de 1.9kg (50 unités)",
      "unite_commande": "sac",
      "contenance": 1.9,
      "unite_contenance": "kg",
      "nb_unites": 50,
      "prix_unitaire_ht": 18.50,
      "minimum_commande": 1,
      "maximum": null,
      "utilise_commande": true,
      "utilise_inventaire": true
    },
    {
      "nom": "Carton de 4 sacs",
      "unite_commande": "carton",
      "contenance": 7.6,
      "unite_contenance": "kg",
      "nb_unites": 4,
      "nb_sous_unite": "sacs de 1.9kg",
      "prix_unitaire_ht": 72.00,
      "minimum_commande": 1,
      "maximum": null,
      "utilise_commande": false,
      "utilise_inventaire": false
    }
  ]
}
```

**Règles conditionnements :**
- **`utilise_commande`** : Radio button (un seul actif) — détermine le conditionnement par défaut pour la commande
- **`utilise_inventaire`** : Checkbox (plusieurs possibles) — détermine les conditionnements disponibles pour compter lors de l'inventaire
- **`maximum`** : Quantité maximale commandable (optionnel, null = pas de limite)
- **`nb_unites`** : Nombre d'unités de base contenues dans ce conditionnement (ex: sac de 50 nems → 50)
```

Le conditionnement utilisé pour la commande est **pré-paramétré par article** dans la mercuriale. L'opérateur ne le choisit pas à chaque commande. La recommandation est calculée en unité de stock, puis convertie en nombre du conditionnement paramétré.

Si besoin de changer le conditionnement d'un article, c'est l'admin qui modifie la fiche dans la mercuriale.

### 3.2 Profil fournisseur

**Données par fournisseur :**

| Champ | Type | Description |
|---|---|---|
| `nom` | string | Raison sociale |
| `contact_nom` | string | Nom du contact commercial |
| `email_commande` | string | Email pour l'envoi des bons de commande |
| `telephone` | string | Téléphone |
| `jours_commande` | array | Jours où l'on peut passer commande (ex: ["lundi", "mercredi"]) |
| `heure_limite_commande` | string | Heure limite pour passer commande (ex: "14:00") |
| `jours_livraison` | array | Jours de livraison possibles |
| `delai_commande_livraison` | object | Mapping jour commande → jour livraison (ex: "lundi" → "mercredi") |
| `franco_minimum` | number | Montant minimum de commande (franco) - **BLOQUANT** : envoi impossible si non atteint |
| `conditions_paiement` | string | Conditions de paiement |
| `mode_envoi` | string | "email" (défaut) ou "EDI" (futur) |
| `adresse` | string | Adresse du fournisseur |
| `notes` | string | Commentaires / instructions spéciales |

### 3.3 Processus de passation de commande

```
1. L'opérateur sélectionne un fournisseur
2. Le système vérifie :
   - Est-on dans un jour/heure autorisé pour commander ?
   - Si non : alerte + affichage du prochain créneau possible
3. Le système affiche la mercuriale du fournisseur
4. Pour chaque produit, le système affiche :
   - Stock actuel (théorique)
   - Stock tampon défini
   - Quantité recommandée (basée sur la prévision + stock tampon)
   - Dernière commande (date, quantité, prix)
5. L'opérateur ajuste les quantités (gros boutons +/- pour iPad)
6. L'opérateur définit la période couverte par la commande
   (ex: "commande pour 3 jours" → ajuste les recommandations)
   Note: la durée est choisie manuellement par l'opérateur.
   Le profil fournisseur affiche les jours de livraison et délais
   pour aider l'opérateur à choisir la bonne période.
7. Auto-save permanent pendant la saisie
8. Le système vérifie le franco minimum :
   - Si total < franco → BLOCAGE, message "Minimum XX€, il manque YY€"
   - L'opérateur doit ajouter des articles ou annuler
9. Validation → Prévisualisation de l'email + PDF du bon de commande
10. Confirmation → Envoi de l'email
```

### 3.4 Bon de commande (PDF)

**Librairie : jsPDF + jspdf-autotable** (génération client-side)
- Bundle léger : ~526 KB (vs ~3.6 MB pour pdfmake) — essentiel pour PWA sur iPad
- Fonctionne hors-ligne (pas de serveur requis)
- `jspdf-autotable` pour les tableaux de commande formatés automatiquement
- Le PDF généré est sauvegardé dans Supabase Storage (`pdfs` bucket) + envoyé par email

**Format du PDF :**
- Titre du fichier : `BC{AAAAMMJJ}-{NNN}.pdf` (ex: `BC20260303-001.pdf`)
- En-tête : logo Phood (PNG/SVG embarqué), adresse restaurant, date, numéro de commande
- Tableau : référence, désignation, quantité, unité, prix unitaire HT, total HT
- Pied : total HT, TVA, total TTC
- Mention des conditions de livraison
- Couleurs et police : charte graphique Phood

**Format de l'email :**
- Objet : `{date} | Nouvelle commande | Phood | Bègles | BC{AAAAMMJJ}-{NNN}`
  - Exemple : `03/03 | Nouvelle commande | Phood | Bègles | BC20260303-001`
- Corps :
  ```
  Bonjour,
  Veuillez trouver ci-joint le bon de commande.
  Cordialement,
  ```
- Expéditeur : `team.begles@phood-restaurant.fr` (Google Workspace)
- Pièce jointe : le PDF du bon de commande

### 3.5 Recommandation de quantité

La quantité recommandée pour chaque produit est calculée ainsi :

```
quantite_recommandee =
    (consommation_prevue_pour_la_periode)
  + (stock_tampon)
  - (stock_actuel)
```

Où :
- `consommation_prevue_pour_la_periode` = prévision CA par produit caisse × quantité ingrédient par recette, sur la durée définie par l'opérateur
- `stock_tampon` = valeur définie par produit dans la mercuriale
- `stock_actuel` = stock théorique (dernière synchro Zelty - ventes)

Si le résultat est négatif ou nul → pas de recommandation (stock suffisant).

**Stock en transit (commandes en attente de livraison) :**
Le calcul DOIT tenir compte des commandes déjà passées mais non encore livrées :

```
quantite_recommandee =
    (consommation_prevue_pour_la_periode × (1 + pertes_pct/100))
  + (stock_tampon)
  - (stock_actuel)
  - (stock_en_transit)  ← quantités commandées non encore reçues
```

Le facteur `pertes_pct` est défini par ingrédient fournisseur (ex: 5% de perte sur les nems = on commande 5% de plus).

Le stock en transit est clairement affiché dans l'aide à la commande pour chaque produit.

**Détail expandable (chevron ▼) par produit dans la mercuriale :**
Chaque ligne de la mercuriale de commande dispose d'un chevron qui déploie un panneau avec le détail du calcul de la recommandation :
- Prévision de consommation pour la période (ventilée par produit caisse si applicable)
- Stock actuel (avec date de dernière mise à jour)
- Stock en transit (quantités commandées non reçues, avec date livraison prévue)
- Stock tampon appliqué (semaine/weekend/vacances selon la période)
- Pertes estimées (% appliqué)
- **Alerte si données de stock anciennes** : Si aucune donnée de stock réel (inventaire) n'est disponible dans les 30 derniers jours pour cet ingrédient, un message d'alerte est affiché : "Aucune donnée de stock réel disponible dans les 30 derniers jours"

**Toggle "Pré-remplir avec les recommandations" :**
Un toggle en haut de la mercuriale de commande permet de pré-remplir toutes les quantités avec les recommandations calculées. Par défaut désactivé (quantités à 0). L'opérateur peut activer ce toggle puis ajuster manuellement chaque ligne.

---

## 4. Module 2 : Réception et contrôle

### 4.1 Workflow de réception

```
[Commande passée]
     |
     v
[Commande envoyée au fournisseur] ← statut: "envoyée"
     |
     v
[Livraison reçue] ← l'opérateur ouvre le contrôle réception
     |
     v
[Photo du bon de livraison (BL)] ← prise depuis l'iPad
     |
     v
[IA analyse le BL] ← OpenAI Vision extrait les données
     |
     v
[Comparaison automatique BC vs BL]
     |
     ├── Lignes conformes → ✅ validées automatiquement
     |
     └── Lignes avec écart → ⚠️ signalées à l'opérateur
           |
           v
     [L'opérateur traite chaque anomalie]
           |
           ├── Sélection du type d'anomalie :
           |     - Produit manquant
           |     - Quantité différente
           |     - Produit cassé / endommagé
           |     - Produit substitué
           |     - Qualité non conforme (DLC courte, produit abîmé...)
           |     - Prix différent
           |     - Produit non commandé livré
           |
           ├── Switch conditionnement pour déclarer l'anomalie :
           |     L'opérateur peut changer le conditionnement de comptage
           |     pour déclarer l'anomalie dans l'unité la plus intuitive.
           |     Ex: commandé 2 colis x12 bouteilles, 4 bouteilles cassées
           |     → switch en "Bouteille" : BDL = 24, Reçu = 20
           |     → ou rester en "Colis" : BDL = 2, Reçu = 1.67
           |     Le système convertit automatiquement entre conditionnements.
           |
           ├── Calcul automatique de la balance (écart en €) :
           |     balance = (quantité_BDL - quantité_reçue) × prix_unitaire
           |     Ex: 4 bouteilles cassées × (14.88€ / 12) = -4.96 EUR
           |
           ├── Prise de photo de l'anomalie (optionnel mais recommandé)
           |
           ├── Saisie DLC/DDM du produit reçu (date sélecteur)
           |
           └── Demande d'avoir si non-conformité
                 |
                 ├── Récapitulatif auto :
                 |     - Tableau des lignes en anomalie (description, SKU,
                 |       prix BC vs BDL, qté BDL vs reçue, anomalie, balance, total)
                 |     - Total HT de l'avoir
                 |
                 ├── Envoi email configurable :
                 |     - Destinataires* : email fournisseur (pré-rempli) + internes
                 |     - Copies (CC) : configurable (ex: team.begles@...)
                 |     - Commentaire libre (ex: "4 bouteilles pétillantes endommagées")
                 |     - Photos justificatives en pièce jointe
                 |
                 ├── Deux options de validation :
                 |     - [Envoyer] → envoie l'email ET valide l'avoir
                 |     - [Valider sans envoyer] → valide l'avoir dans l'app
                 |       sans envoyer d'email (pour traçabilité interne uniquement)
                 |
                 └── ⚠️ DÉLAI : 72h max après réception pour que la
                     prise en charge fonctionne → alerte si anomalie
                     non traitée après 48h
```

### 4.2 Statuts d'une commande

| Statut | Description | Couleur |
|---|---|---|
| `brouillon` | Commande en cours de saisie (auto-saved, persistant, reprise possible plus tard) | Gris |
| `envoyee` | Email envoyé au fournisseur. Les quantités sont comptées comme "stock en transit" | Gris foncé |
| `receptionnee` | Livraison physiquement reçue, contrôle en cours | Bleu |
| `controlee` | Contrôle BL terminé, en attente de décision finale | Orange |
| `validee` | Réception conforme, commande clôturée | Vert |
| `avoir_en_cours` | Non conforme, demande d'avoir envoyée au fournisseur | Rouge |
| `cloturee` | Commande terminée (avoir traité ou commande validée) | Gris |

**Modification/annulation d'une commande envoyée :**
- Pas d'annulation pure : on modifie la commande (repassée en brouillon)
- Au nouvel envoi, l'email contient en objet : `{date} | Commande modifiée | Phood | Bègles | BC{numero}`
- Le corps de l'email mentionne : "Cette commande annule et remplace la commande précédente BC{numero}"
- Seul Admin/Manager peut modifier une commande déjà envoyée

**Chaîne de statuts complète :**
```
[Brouillon] → [Envoyée] → [Réceptionnée] → [Contrôlée] → [Validée]
                                                        └→ [Avoir en cours] → [Clôturée]
```

### 4.3 Lecture IA du bon de livraison

**Input :** Photo du bon de livraison (prise par l'opérateur sur iPad)

**Traitement (OpenAI GPT-4 Vision) :**
1. Extraction des données du BL : références, désignations, quantités livrées, prix
2. Matching avec les lignes du bon de commande correspondant
3. Identification des écarts (quantité, prix, produit manquant/supplémentaire)

**Output :** Tableau comparatif pré-rempli BC vs BL avec écarts surlignés

**Gestion des erreurs IA :**
- Si la photo est illisible → message d'erreur + possibilité de reprendre la photo
- Si l'IA n'est pas confiante sur une ligne → marquée comme "à vérifier manuellement"
- L'opérateur peut toujours corriger/surcharger les valeurs extraites par l'IA
- Si hors-ligne → la photo est stockée, l'analyse IA se fait à la reconnexion

### 4.4 Demande d'avoir

**Email de demande d'avoir :**
- Objet : `{date} | Demande d'avoir | Phood | Bègles | BC{numero}`
- Corps :
  - Tableau récapitulatif des anomalies :
    - Description | SKU
    - Prix u. HT BDC vs BDL
    - Qté BDL vs Reçue (en conditionnement d'origine)
    - Motif d'anomalie
    - Balance (écart en €)
    - Total HT BDL vs Reçu
  - Total HT de l'avoir demandé
  - Commentaire libre de l'opérateur
- PJ : photo(s) justificatives de l'anomalie
- Destinataires : email fournisseur (pré-rempli depuis le profil) + destinataires internes configurables
- CC : configurable (ex: `team.begles@phood-restaurant.fr`)
- Expéditeur : `team.begles@phood-restaurant.fr`

**Option "Valider sans envoyer" :**
L'opérateur peut valider l'avoir dans l'app SANS envoyer d'email (ex: accord verbal avec le livreur, avoir déjà traité sur place). L'anomalie est tracée, la balance est calculée, mais pas d'email envoyé. Utile pour la traçabilité interne.

### 4.5 Suivi des demandes d'avoir

**Statuts d'une demande d'avoir :**

| Statut | Description |
|---|---|
| `envoyee` | Email envoyé au fournisseur |
| `reponse_recue` | Le fournisseur a répondu (détectée via Gmail API) |
| `en_attente_validation` | Réponse reçue, admin doit décider |
| `validee` | Admin a validé la prise en charge |
| `relance` | Relance envoyée (pas de réponse après X jours) |
| `cloturee` | Avoir confirmé / dossier clos |

**Workflow de suivi :**
```
[Demande d'avoir envoyée]
     |
     ├── Pas de réponse après 3 jours ouvrés
     |     → Relance automatique proposée à l'admin
     |     → Email de relance pré-rédigé (1 clic pour envoyer)
     |
     └── Réponse du fournisseur détectée (Gmail API)
           |
           v
     [Notification à l'Admin]
     "Réponse de Transgourmet à votre demande d'avoir BC20260301-002"
           |
           ├── Admin consulte la réponse
           |
           ├── Admin VALIDE la prise en charge
           |     → Statut "validée" + archivage
           |
           └── Admin RELANCE / CONTESTE
                 → Nouveau message au fournisseur
```

**Détection des réponses fournisseurs :**
- Le système surveille les emails entrants sur `team.begles@phood-restaurant.fr` (via Gmail API - polling périodique)
- Matching par objet d'email (contient le numéro BC) ou par thread Gmail
- Toute réponse dans le thread de la demande d'avoir est détectée
- L'admin est notifié dans le dashboard (section Alertes)
- L'email du fournisseur est consultable directement depuis la fiche avoir dans l'app

---

## 5. Module 3 : Gestion des recettes et stocks

### 5.1 Architecture des données produits

Le système repose sur une **architecture à 3 niveaux** (identique à inpulse.ai) :

```
[Ingrédient Fournisseur]        ← ce qu'on commande (ref mercuriale)
         |                        Ex: "Poulet émincé 2.5kg - Transgourmet"
         | (N:1 - rare mais possible : 2 fournisseurs pour un même ingrédient)
         v
[Ingrédient Restaurant]         ← ce qu'on utilise en cuisine
         |                        Ex: "Poulet émincé"
         | (1:N - un ingrédient entre dans 3-10 recettes en moyenne)
         v
[Recette / Produit Caisse]      ← ce qu'on vend (synchro Zelty)
                                  Ex: "Bo bun poulet" (contient poulet, vermicelles, légumes...)
```

**Cas particuliers :**

1. **Produits sans recette** (boissons, snacks, produits revendus) :
   - Le produit caisse Zelty est lié DIRECTEMENT à un ingrédient fournisseur
   - Pas d'ingrédient restaurant intermédiaire nécessaire
   - Décrémentation = 1 unité vendue = 1 unité de stock en moins
   - Ex: "Coca-Cola 33cl" vendu sur Zelty = 1 "Coca-Cola 33cl" déstocké

2. **Menus Zelty** :
   - Les menus sont composés de produits individuels différenciés sur Zelty
   - Pas besoin de décomposer : Zelty envoie déjà les ventes par produit individuel
   - Le menu n'est qu'un regroupement commercial côté caisse

3. **Multi-fournisseur** (rare mais supporté) :
   - Un ingrédient restaurant peut avoir 1 fournisseur préféré + fournisseurs alternatifs
   - Lors de la commande, le système utilise le fournisseur préféré par défaut
   - L'admin peut changer le fournisseur préféré si besoin (rupture, prix, etc.)

4. **Sous-recettes** :
   - Une sous-recette (sauce, marinade) est un ingrédient restaurant "fabriqué"
   - Elle a sa propre composition en ingrédients
   - Elle est utilisée comme ingrédient dans d'autres recettes
   - La décrémentation remonte aux ingrédients de base (pas de stock de sous-recette)

### 5.2 Ingrédient fournisseur

Référence produit achetée chez un fournisseur spécifique.
→ Voir section 3.1 (mercuriale) pour les champs détaillés.

### 5.3 Ingrédient restaurant

L'ingrédient tel qu'utilisé dans les recettes du restaurant.

| Champ | Type | Description |
|---|---|---|
| `id` | string | Identifiant unique |
| `nom` | string | Nom de l'ingrédient (ex: "Poulet émincé") |
| `unite_stock` | string | Unité de stockage/utilisation (kg, litre, pièce...) |
| `ingredients_fournisseur_ids` | array | Liste des ingrédients fournisseur liés (un ou plusieurs fournisseurs possibles) |
| `fournisseur_prefere_id` | string | Fournisseur par défaut pour cet ingrédient (détermine aussi le coût, voir 5.5b) |
| `cout_unitaire` | number | Coût par unité de stock (€/kg, €/L, €/pièce). Calculé automatiquement (voir 5.5b) |
| `cout_source` | string | Origine du coût actuel : "mercuriale" ou "reception" (mis à jour auto) |
| `cout_maj_date` | date | Date de dernière mise à jour du coût unitaire |
| `rendement` | number | Coefficient de rendement (ex: 0.85 = 15% de perte à la préparation) |
| `categorie` | string | Catégorie (viandes, légumes, sauces, épices...) |
| `allergenes` | array | Liste des 14 allergènes obligatoires (auto-détectés par IA depuis photo packaging ou saisis manuellement) |
| `contient` | array | Liste libre de sous-ingrédients connus (pour les produits achetés tout prêts, ex: sauce). Sans quantités, uniquement les noms. Utilisé par la recherche allergènes (voir 5.4b) |
| `stock_actuel` | number | Stock théorique actuel (en unité stock) |
| `photo_url` | string | Photo de l'ingrédient |

### 5.4 Recette / Produit caisse

| Champ | Type | Description |
|---|---|---|
| `id` | string | Identifiant unique |
| `zelty_product_id` | string | ID produit dans Zelty |
| `nom` | string | Nom du plat/produit |
| `categorie` | string | Catégorie (entrées, plats, desserts, boissons...) |
| `prix_vente` | object | Prix de vente par canal (voir 5.4f) : `{sur_place: {ttc, tva}, emporter: {ttc, tva}, livraison: {ttc, tva}}` |
| `ingredients` | array | Liste des ingrédients avec quantités (voir ci-dessous) |
| `cout_matiere_base` | number | Coût matière des ingrédients (calculé auto, sans emballage) |
| `cout_emballage` | number | Coût de l'emballage pour emporter/livraison (0 si sur place uniquement) |
| `photo_url` | string | Photo du plat |
| `actif` | boolean | Produit actif en carte (les produits inactifs ne sont plus proposés dans les prévisions) |
| `instructions` | string | Instructions de préparation (texte libre) |
| `variantes` | array | Variantes de taille avec quantités ajustées (voir 5.4c) |
| `modificateurs` | array | Extras et "sans" avec impact stock (voir 5.4d) |

**Structure d'un ingrédient dans une recette :**
```json
{
  "ingredient_restaurant_id": "xxx",
  "quantite": 0.150,
  "unite": "kg",
  "notes": "émincé fin"
}
```

**Ou référence vers une sous-recette :**
```json
{
  "sous_recette_id": "yyy",
  "quantite": 0.050,
  "unite": "kg"
}
```

### 5.4b Sous-recettes

Certaines préparations de base (sauces, marinades, panures) sont utilisées dans plusieurs plats. Elles sont modélisées comme des recettes sans `zelty_product_id` (non vendues directement).

| Champ | Type | Description |
|---|---|---|
| `id` | string | Identifiant unique |
| `nom` | string | Nom de la sous-recette (ex: "Crousty base", "Marinade PPC") |
| `type` | string | "sous_recette" (vs "produit_caisse" pour les plats vendus) |
| `categorie` | string | Catégorie (Préparation, Sauce, Marinade, etc.) — configurable par admin |
| `ingredients` | array | Liste des ingrédients avec quantités (peut inclure d'autres sous-recettes) |
| `rendement` | number | Quantité produite à partir des ingrédients (ex: 1700g de crousty base) |
| `unite_sortie` | string | Unité de la sous-recette (g, kg, litre...) |
| `cout_matiere` | number | Coût matière calculé automatiquement (récursivement à travers les sous-recettes) |
| `photo_url` | string | Photo du produit fini |
| `instructions` | string | Instructions de préparation (texte libre) |
| `actif` | boolean | Sous-recette active ou archivée |

**Imbrication des sous-recettes (jusqu'à 3 niveaux) :**
```
Exemple concret :
[Sauce soja maison]        ← Niveau 3 (sous-recette de base)
       ↓
[Marinade PPC]             ← Niveau 2 (contient sauce soja + autres ingrédients)
       ↓
[Crousty base]             ← Niveau 1 (contient marinade + farine + poulet...)
       ↓
[Crousty Gà]               ← Produit vendu (contient 100g de crousty base)
```

Le calcul du coût matière et la décrémentation des stocks remontent **toujours récursivement** jusqu'aux ingrédients de base.

**Pas de stock physique pour les sous-recettes :**
Les sous-recettes n'ont PAS de stock suivi dans l'app. Elles servent uniquement à :
- Calculer le **coût matière** des produits vendus (récursivement à travers les niveaux)
- **Décrémenter les stocks** des ingrédients de base quand un produit est vendu

L'équipe prépare physiquement en batch (ex: 5kg de crousty base), mais il n'y a aucune saisie de production dans l'app. Seuls les ingrédients de base (farine, poulet, huile...) ont un stock suivi.

**Vue "Éléments utilisant cette recette" (V1) :**
Chaque fiche recette/sous-recette/ingrédient affiche la liste des éléments qui l'utilisent :
- Nom de l'élément parent
- Type (Recette, Sous-recette, Supplément)
- Catégorie
- Quantité utilisée
- Statut (Actif/Inactif)

Cette vue est essentielle pour évaluer l'impact d'une modification (changement de prix, changement de fournisseur, retrait d'un ingrédient).

**Recherche rapide allergènes / ingrédients (V1) :**

Bouton d'accès rapide depuis le dashboard ou la barre de navigation : **🔍 "Vérif allergènes"**

Cas d'usage : un client au comptoir dit "je suis allergique à la tomate". L'équipier tape "tomate" et voit instantanément tous les produits actifs concernés.

```
┌──────────────────────────────────────────────────┐
│  🔍 Vérif allergènes                      [✕]   │
│                                                   │
│  Rechercher : [tomate________] ← autocomplétion  │
│                                                   │
│  🍅 Tomate — présente dans 8 produits actifs :   │
│                                                   │
│  ❌ Bo bun poulet (tomates cerises)               │
│  ❌ Bo bun boeuf (tomates cerises)                │
│  ❌ Bo bun tofu (tomates cerises)                 │
│  ❌ Riz Sauté poulet (via sauce tomate maison)    │
│  ❌ Riz Sauté boeuf (via sauce tomate maison)     │
│  ❌ Curry Rouge (via pâte de curry)               │
│  ✅ Phried Rice poulet — SANS tomate              │
│  ✅ Crazy Tenders — SANS tomate                   │
│  ✅ Chicken Wings — SANS tomate                   │
│                                                   │
│  💡 Proposer au client : Phried Rice, Crazy       │
│     Tenders, Chicken Wings                        │
└──────────────────────────────────────────────────┘
```

**Fonctionnement technique :**
- Recherche en texte libre sur les noms d'ingrédients restaurant (fuzzy matching)
- Parcours récursif à travers les sous-recettes (ex: "tomate" dans "sauce tomate maison" → tous les plats utilisant cette sous-recette)
- Recherche aussi dans le champ `contient` des ingrédients achetés (ex: "citronnelle" trouvée dans la composition déclarée de "Sauce Boeuf Citronnelle")
- Affiche les produits actifs en carte uniquement
- Résultat en <1 seconde (requête Supabase simple, données déjà en cache IndexedDB)
- Accessible à tous les rôles (opérateur inclus)
- Couvre TOUS les ingrédients, pas seulement les 14 allergènes obligatoires

**Cas des ingrédients achetés tout prêts (sauces, préparations fournisseur) :**
Certains ingrédients sont reçus prêts à l'emploi sans sous-recette dans PhoodApp (ex: Sauce Boeuf Citronnelle, Sauce Poulet Gingembre, Sauce Pad Thai...). Pour que la recherche allergènes soit fiable sur ces produits, le champ `contient` de l'ingrédient restaurant permet de lister leurs sous-ingrédients connus, sans quantités :

```json
{
  "nom": "Sauce Boeuf Citronnelle",
  "contient": ["boeuf", "citronnelle", "sauce soja", "sucre", "ail", "piment"]
}
```

- Renseignement : saisie manuelle OU extraction IA depuis photo de l'étiquette (même processus que la détection allergènes, voir section 11)
- **IA (V1)** : lors de la photo packaging, GPT-4.1-mini extrait en un seul appel : les 14 allergènes réglementaires → champ `allergenes` ET la liste complète des ingrédients → champ `contient`
- Si `contient` est vide → la recherche affiche un avertissement : "⚠️ Composition inconnue — vérifier manuellement auprès du fournisseur"

> **Pas de doublon avec Belorder :** Belorder affiche les 14 allergènes obligatoires au client sur la borne. PhoodApp répond à un besoin différent : recherche libre sur N'IMPORTE quel ingrédient ("tomate", "cacahuète", "sésame", "lait de coco"...) pour répondre à un client au comptoir en temps réel.

**Notification "Compositions manquantes" et upload massif de photos :**

PhoodApp détecte automatiquement les ingrédients achetés tout prêts (sans sous-recette) dont le champ `contient` est vide. Une **notification persistante** (🔔 clochette + badge compteur) s'affiche tant que des compositions manquent.

Notification : `"X ingrédients sans composition connue — compléter pour fiabiliser la recherche allergènes"`

**Flux d'upload massif (batch) :**

Le flux est conçu pour être rapide : l'admin ne navigue PAS produit par produit. Il uploade toutes ses photos d'étiquettes d'un coup, puis l'IA fait le matching.

```
┌─────────────────────────────────────────────────────────────┐
│  📸 Compléter les compositions manquantes    [12 restants]  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Étape 1 : Upload massif                                    │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                                                       │  │
│  │   📷  Prendre des photos / Importer depuis galerie    │  │
│  │                                                       │  │
│  │   Glissez vos photos d'étiquettes ici                 │  │
│  │   ou appuyez pour photographier                       │  │
│  │                                                       │  │
│  │   [+ Ajouter photos]  (multi-sélection)               │  │
│  │                                                       │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  Photos importées : 8 / 12                                  │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐    │
│  │ 📷 1 │ │ 📷 2 │ │ 📷 3 │ │ 📷 4 │ │ 📷 5 │ │ 📷 6 │    │
│  │  ✅  │ │  ✅  │ │  ✅  │ │  ⏳  │ │  ⏳  │ │  ⏳  │    │
│  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘    │
│  ┌──────┐ ┌──────┐                                         │
│  │ 📷 7 │ │ 📷 8 │                                         │
│  │  ⏳  │ │  ⏳  │                                         │
│  └──────┘ └──────┘                                         │
│                                                             │
│  [🚀 Lancer l'extraction IA]                                │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Étape 2 : Résultats & association                          │
│                                                             │
│  L'IA a extrait les compositions. Vérifiez les associations │
│  automatiques et corrigez si nécessaire :                    │
│                                                             │
│  📷 1 → 🤖 "Sauce Boeuf Citronnelle"  ✅ auto-match       │
│         Extrait : boeuf, citronnelle, sauce soja, sucre,   │
│                   ail, piment, huile de sésame              │
│         Allergènes détectés : 🥜 Soja, 🌾 Sésame           │
│                                          [✔ Valider]       │
│                                                             │
│  📷 2 → 🤖 "Sauce Pad Thai"  ✅ auto-match                │
│         Extrait : tamarin, sucre de palme, sauce poisson,   │
│                   piment, ail                               │
│         Allergènes détectés : 🐟 Poisson                   │
│                                          [✔ Valider]       │
│                                                             │
│  📷 3 → ⚠️ Pas de correspondance trouvée                   │
│         Extrait : lait, crème, sucre, vanille               │
│         [🔍 Sélectionner l'ingrédient ▼]   [✔ Valider]    │
│                                                             │
│  ──────────────────────────────────────────────────────────  │
│  [✅ Tout valider]  (valide les matchs auto uniquement)     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Fonctionnement détaillé :**

1. **Détection auto** : PhoodApp identifie les ingrédients sans sous-recette ET sans `contient` renseigné → compteur affiché dans la clochette 🔔
2. **Upload batch** : L'admin peut prendre des photos ou importer depuis la galerie iPad, en multi-sélection. Pas besoin d'associer manuellement chaque photo à un produit avant l'upload
3. **Extraction IA** : GPT-4.1-mini traite toutes les photos en parallèle (un appel par photo). Pour chaque photo, il extrait :
   - Le **nom du produit** visible sur l'étiquette
   - La **liste des ingrédients** → champ `contient`
   - Les **14 allergènes** détectés → champ `allergenes`
4. **Matching auto** : Le nom extrait est comparé (fuzzy match) aux ingrédients de la liste "compositions manquantes". Si confiance ≥ 90% → auto-match ✅. Sinon → l'admin sélectionne manuellement dans un dropdown
5. **Validation** : L'admin peut valider individuellement ou en masse ("Tout valider" pour les auto-matchs). Les champs `contient` et `allergenes` sont mis à jour
6. **Compteur mis à jour** : Le badge de la clochette diminue en temps réel. Quand tout est renseigné → la notification disparaît

**Fréquence de la notification :**
- Apparaît dès qu'un nouvel ingrédient achetable sans composition est créé
- Rappel hebdomadaire par email si le compteur reste > 0 pendant plus de 7 jours
- Non bloquante : n'empêche pas d'utiliser les autres fonctionnalités

### 5.4c Variantes de taille (Normal / Grand)

Sur Zelty, les tailles sont gérées comme **options sur un même produit** (ex: Bo bun → option "Normal" ou "Grand"). Chaque variante a des quantités d'ingrédients différentes.

**Structure des variantes :**
```json
{
  "recette": "Bo bun poulet",
  "zelty_product_id": "xxx",
  "ingredients_base": [...],
  "variantes": [
    {
      "nom": "Normal",
      "zelty_option_id": "opt_normal",
      "coefficient": 1.0
    },
    {
      "nom": "Grand",
      "zelty_option_id": "opt_grand",
      "coefficient": 1.5
    }
  ]
}
```

**Décrémentation :**
- Bo bun Normal vendu → ingrédients × 1.0
- Bo bun Grand vendu → ingrédients × 1.5 (ou coefficient personnalisé)
- Le coefficient est configurable par variante (pas forcément linéaire)

**Alternative :** Si le coefficient unique ne suffit pas (ex: le Grand a plus de viande mais même quantité de sauce), on peut définir des quantités spécifiques par variante par ingrédient :

```json
{
  "variantes": [
    {
      "nom": "Grand",
      "zelty_option_id": "opt_grand",
      "ingredients_override": [
        {"ingredient_restaurant_id": "poulet", "quantite": 0.250},
        {"ingredient_restaurant_id": "vermicelles", "quantite": 0.200}
      ]
    }
  ]
}
```
Les ingrédients non listés dans `ingredients_override` utilisent la quantité de base.

### 5.4d Modificateurs (Extras et "Sans")

Sur Zelty, les extras ("+extra poulet") et les retraits ("sans coriandre") sont des **options/modificateurs** sur le produit.

**Structure des modificateurs :**
```json
{
  "modificateurs": [
    {
      "nom": "Extra poulet",
      "zelty_option_id": "mod_extra_poulet",
      "type": "extra",
      "impact_stock": [
        {"ingredient_restaurant_id": "poulet", "quantite": 0.080, "unite": "kg"}
      ]
    },
    {
      "nom": "Extra cacahuètes",
      "zelty_option_id": "mod_extra_cacahuetes",
      "type": "extra",
      "impact_stock": [
        {"ingredient_restaurant_id": "cacahuetes", "quantite": 0.030, "unite": "kg"}
      ]
    },
    {
      "nom": "Sans coriandre",
      "zelty_option_id": "mod_sans_coriandre",
      "type": "sans",
      "impact_stock": [
        {"ingredient_restaurant_id": "coriandre", "quantite": -0.010, "unite": "kg"}
      ]
    }
  ]
}
```

**Décrémentation avec modificateurs :**
```
stock_décrémenté = recette_base (× coefficient_taille)
                 + extras sélectionnés
                 - "sans" sélectionnés
```

**Exemple concret :**
- Bo bun Grand + Extra poulet + Sans coriandre =
  - Recette base × 1.5
  - + 80g poulet (extra)
  - - 10g coriandre (sans)

**Point d'attention API Zelty :**
- Vérifier que l'API Zelty renvoie les options/modificateurs sélectionnés dans les données de vente
- Mapper chaque option Zelty (`zelty_option_id`) vers un impact stock dans PhoodApp
- Les modificateurs sont configurés au niveau de la recette (chaque plat a ses propres extras possibles)

### 5.4e Création rapide de recette assistée par IA

**Problème :** La saisie d'une recette classique (nom, ingrédients un par un avec quantités/unités, instructions) est fastidieuse et freine la création de nouvelles fiches.

**Solution : zone texte libre + parsing IA**

L'admin colle le texte brut de sa recette (copié d'un document, d'un message, ou tapé librement) dans une zone de texte unique. L'IA analyse le texte et pré-remplit automatiquement le formulaire.

**Flow utilisateur :**
```
1. Bouton "+ Nouvelle recette" → formulaire avec 2 zones :
   ┌─────────────────────────────────────────────────┐
   │  Nom de la recette : [________________]         │
   │                                                  │
   │  📋 Colle ta recette ici (texte libre) :        │
   │  ┌─────────────────────────────────────────────┐ │
   │  │ 150g poulet émincé                          │ │
   │  │ 100g vermicelles de riz                     │ │
   │  │ 50ml sauce nuoc mam maison                  │ │
   │  │ 30g cacahuètes concassées                   │ │
   │  │ salade, menthe, carottes râpées             │ │
   │  │                                             │ │
   │  │ Faire mariner le poulet 30min...            │ │
   │  └─────────────────────────────────────────────┘ │
   │                                                  │
   │  [🤖 Analyser avec l'IA]                        │
   └─────────────────────────────────────────────────┘

2. L'IA (GPT-4.1-mini, structured output) extrait :
   - Les ingrédients détectés avec quantités et unités
   - Les correspondances avec les ingrédients restaurant existants
   - Les étapes de préparation (séparées des ingrédients)

3. Résultat affiché pour validation :
   ┌─────────────────────────────────────────────────┐
   │  ✅ Ingrédients détectés :                      │
   │  ┌──────────────┬────────┬───────┬───────────┐  │
   │  │ Ingrédient   │ Qté    │ Unité │ Lié à     │  │
   │  ├──────────────┼────────┼───────┼───────────┤  │
   │  │ Poulet émincé│ 150    │ g     │ ✅ Poulet │  │
   │  │ Vermicelles  │ 100    │ g     │ ✅ Verm.  │  │
   │  │ Sauce nuoc   │ 50     │ mL    │ ✅ S-rec  │  │
   │  │ Cacahuètes   │ 30     │ g     │ ✅ Cacah. │  │
   │  │ Salade       │ —      │ —     │ ⚠️ Qté ?  │  │
   │  │ Menthe       │ —      │ —     │ ⚠️ Qté ?  │  │
   │  │ Carottes     │ —      │ —     │ ⚠️ Qté ?  │  │
   │  └──────────────┴────────┴───────┴───────────┘  │
   │                                                  │
   │  📝 Instructions (auto-extraites) :             │
   │  "Faire mariner le poulet 30min..."             │
   │                                                  │
   │  [Corriger]  [✅ Valider et créer la recette]   │
   └─────────────────────────────────────────────────┘

4. L'admin corrige les quantités manquantes (⚠️) et valide
5. La recette est créée avec ingrédients + instructions
```

**Détails du parsing IA :**
- Prompt structuré avec la liste des ingrédients restaurant existants (noms + IDs)
- Matching flou (fuzzy) : "poulet" → "Poulet émincé", "sauce nuoc mam" → sous-recette "Nuoc mam maison"
- Si un ingrédient n'existe pas encore → proposer de le créer (bouton "Créer cet ingrédient")
- Détection intelligente : les lignes avec quantités = ingrédients, les phrases longues = instructions
- Structured output JSON : `{ingredients: [{nom, quantite, unite, match_id, confiance}], instructions: "..."}`

**Formats acceptés (exemples de texte libre) :**
```
Format 1 : "150g poulet, 100g vermicelles, 50ml sauce"
Format 2 : "poulet émincé 150 grammes\nvermicelles 100g"
Format 3 : "- 150g de poulet\n- 100g de vermicelles de riz"
Format 4 : texte mixte ingrédients + étapes (l'IA sépare)
```

**Coût API estimé :** ~0.001€ par recette analysée (GPT-4.1-mini, ~500 tokens input + ~200 output)

### 5.4f Analyse de rentabilité multi-canal et simulateur de prix

**Problème :** Aujourd'hui, Benjamin utilise un Google Sheets séparé ("Contrôle coût_Plats du moment") pour calculer les ratios de rentabilité par canal (sur place, à emporter, en livraison). Le workflow actuel est : calculer le coût matière dans inpulse → copier manuellement dans le Sheets → ajuster les prix de vente pour trouver le bon équilibre avec les autres produits. PhoodApp intègre cette analyse directement.

**3 canaux de vente avec calculs différents :**

| Canal | Coût matière | Prix de vente | Revenu net HT | Particularités |
|---|---|---|---|---|
| 🍽️ **Sur place** | Coût base | Prix TTC sur place | Prix TTC / (1+TVA) | Calcul simple |
| 🥡 **À emporter** | Coût base + emballage | Prix TTC emporter | Prix TTC / (1+TVA) | Surcoût emballage |
| 🛵 **En livraison** | Coût base + emballage | Prix TTC livraison | Prix HT − frais plateforme | Commission plateforme |

**Structure des prix par canal :**
```json
{
  "prix_vente": {
    "sur_place": {"ttc": 12.90, "tva": 10},
    "emporter": {"ttc": 12.90, "tva": 10},
    "livraison": {"ttc": 14.90, "tva": 10}
  },
  "cout_emballage": 0.77
}
```

**Formules de calcul par canal :**

```
═══ SUR PLACE ═══
Prix HT         = Prix TTC / (1 + TVA%)
Coût matière     = cout_matiere_base
Ratio %          = Coût matière / Prix HT
Coefficient      = Prix HT / Coût matière
Marge brute      = Prix HT − Coût matière

═══ À EMPORTER ═══
Prix HT          = Prix TTC / (1 + TVA%)
Coût matière     = cout_matiere_base + cout_emballage
Ratio %          = Coût matière / Prix HT
Coefficient      = Prix HT / Coût matière
Marge brute      = Prix HT − Coût matière

═══ EN LIVRAISON ═══
Prix HT          = Prix TTC / (1 + TVA%)
Commission       = Prix TTC × commission_%    ← appliquée sur le TTC, pas le HT !
Revenu net       = Prix HT − Commission       ← soustraction TTC d'un montant HT (c'est ça le piège)
Coût matière     = cout_matiere_base + cout_emballage
Ratio %          = Coût matière / Revenu net   ← ratio sur ce que le restaurant garde réellement
Coefficient      = Revenu net / Coût matière
Marge brute      = Revenu net − Coût matière
```

> ⚠️ **Pourquoi le calcul livraison est "bizarre" et pénalisant :**
> La commission de la plateforme (Uber Eats, Deliveroo...) est prélevée sur le **prix TTC** (ce que le client paie). Mais le restaurant doit reverser la **TVA à l'État sur le montant TTC complet**, y compris sur la part que la plateforme a gardée. On soustrait donc un montant TTC (la commission) d'un montant HT (le revenu du restaurant après TVA), ce qui crée un double effet pénalisant :
>
> ```
> Exemple concret (Poulet livraison, commission 30%) :
> Client paie           : 14,90€ TTC
> TVA due à l'État      : 14,90 / 1,10 × 10% = 1,35€
> Commission plateforme : 14,90 × 30% = 4,47€  ← sur le TTC !
> Restaurant reçoit     : 14,90 − 4,47 = 10,43€
> Après TVA reversée    : 10,43 − 1,35 = 9,08€  ← revenu net réel
>
> Calcul simplifié      : Prix HT − Commission TTC = 13,55 − 4,47 = 9,08€ ✓
>
> Si la commission était sur le HT : 13,55 − (13,55 × 30%) = 9,49€
> Perte due au calcul sur TTC : 0,41€ par produit !
> ```
>
> C'est pourquoi il est **essentiel** de paramétrer "commission sur TTC" dans PhoodApp pour obtenir des ratios de rentabilité fiables en livraison.

**Configuration des plateformes de livraison :**

Chaque plateforme a **plusieurs taux de commission** selon la méthode de livraison et le type de client (données issues du contrat Uber Eats Phood Bègles, février 2025) :

| Champ | Type | Description |
|---|---|---|
| `nom` | string | Nom de la plateforme (Uber Eats, Deliveroo...) |
| `actif` | boolean | Plateforme active |
| `commissions` | array | Taux par méthode (voir ci-dessous) |
| `prix_max_ecart_pct` | number | Écart max autorisé vs prix sur place (ex: 15% pour Uber Eats) |

**Structure des commissions par plateforme (exemple Uber Eats) :**
```json
{
  "nom": "Uber Eats",
  "actif": true,
  "prix_max_ecart_pct": 15,
  "commissions": [
    {
      "methode": "marketplace",
      "label": "Livraison Uber Eats",
      "standard_pct": 30,
      "abonnement_pct": 33,
      "preferentiel_pct": 26,
      "preferentiel_abonnement_pct": 28,
      "base_calcul": "TTC"
    },
    {
      "methode": "agregateur",
      "label": "Livraison propre",
      "standard_pct": 15,
      "abonnement_pct": 18,
      "base_calcul": "TTC"
    },
    {
      "methode": "click_collect",
      "label": "Click & Collect",
      "standard_pct": 15,
      "abonnement_pct": 18,
      "base_calcul": "TTC"
    }
  ]
}
```

> **Note :** Les taux préférentiels (26%/28%) s'appliquent si les conditions d'exclusivité, disponibilité et marketing sont respectées (voir contrat). PhoodApp permet de basculer entre taux standard et préférentiel via un toggle dans la configuration.

**Calcul dans le simulateur de rentabilité :**
Par défaut, le simulateur utilise le **taux le plus élevé** (pire cas = abonnement Uber One, soit 33% marketplace) pour garantir que la rentabilité affichée est toujours un plancher. L'admin ne risque jamais de surestimer sa marge. Un toggle optionnel permet de basculer sur le taux standard ou préférentiel pour voir le gain potentiel.

**Contrainte de prix Uber Eats :**
Le simulateur affiche une **alerte** si le prix livraison dépasse le seuil autorisé :
```
⚠️ Prix livraison (14,90€) = +15,5% vs sur place (12,90€) → dépasse le plafond Uber Eats de +15%
```

**Interface : fiche recette — onglet "Rentabilité"**

Sur chaque fiche recette, un onglet "Rentabilité" affiche le tableau multi-canal :

```
┌─────────────────────────────────────────────────────────────────────────┐
│  🍜 Riz Sauté — Rentabilité par canal                                 │
│                                                                         │
│  Coût matière base : 0,80€ (auto)    Emballage : [0,77€] ← modifiable │
│                                                                         │
│  ┌──────────────┬──────────────┬──────────────┬──────────────┐         │
│  │   Variante   │ 🍽️ Sur place │ 🥡 Emporter  │ 🛵 Livraison │         │
│  ├──────────────┼──────────────┼──────────────┼──────────────┤         │
│  │              │ TTC [12,90€] │ TTC [12,90€] │ TTC [14,90€] │  ← édit│
│  │              │ HT  11,73€   │ HT  11,73€   │ HT  13,55€   │  auto  │
│  │              │ Commission — │ Commission — │ Comm. 4,47€   │  auto  │
│  │              │ Net  11,73€  │ Net  11,73€  │ Net   9,08€   │  auto  │
│  ├──────────────┼──────────────┼──────────────┼──────────────┤         │
│  │ 🐔 POULET   │              │              │              │         │
│  │ Coût         │ 1,44€        │ 2,21€        │ 2,21€        │         │
│  │ Ratio        │ 12,3% ✅     │ 18,8% ✅     │ 24,3% ⚠️     │         │
│  │ Coeff.       │ ×8,14        │ ×5,31        │ ×4,11        │         │
│  │ Marge        │ 10,29€       │ 9,52€        │ 6,87€        │         │
│  ├──────────────┼──────────────┼──────────────┼──────────────┤         │
│  │ 🐄 BOEUF    │              │              │              │         │
│  │ Coût         │ 1,67€        │ 2,44€        │ 2,44€        │         │
│  │ Ratio        │ 14,2% ✅     │ 20,8% ⚠️     │ 26,9% 🔴     │         │
│  │ Coeff.       │ ×7,02        │ ×4,81        │ ×3,72        │         │
│  │ Marge        │ 10,06€       │ 9,29€        │ 6,64€        │         │
│  ├──────────────┼──────────────┼──────────────┼──────────────┤         │
│  │ 🦐 CREVETTES│              │              │              │         │
│  │ Coût         │ 1,89€        │ 2,66€        │ 2,66€        │         │
│  │ Ratio        │ 16,1% ✅     │ 22,7% ⚠️     │ 29,3% 🔴     │         │
│  │ Coeff.       │ ×6,20        │ ×4,41        │ ×3,41        │         │
│  │ Marge        │ 9,84€        │ 9,07€        │ 6,42€        │         │
│  └──────────────┴──────────────┴──────────────┴──────────────┘         │
│                                                                         │
│  Seuils : ✅ <20%  ⚠️ 20-25%  🔴 >25%   (configurable)               │
│                                                                         │
│  [📊 Comparer avec d'autres produits]                                  │
└─────────────────────────────────────────────────────────────────────────┘
```

**Les prix TTC sont éditables en direct** : l'admin modifie le prix et voit instantanément l'impact sur le ratio, le coefficient et la marge pour chaque variante. Cela permet de **simuler le prix optimal** avant de le publier sur Zelty.

**Seuils d'alerte (configurables globalement) :**
- ✅ Ratio < 20% : rentabilité bonne
- ⚠️ Ratio 20-25% : rentabilité à surveiller
- 🔴 Ratio > 25% : rentabilité insuffisante

**Comparateur de produits :**

Le bouton "Comparer avec d'autres produits" ouvre une vue où l'admin sélectionne des produits à afficher côte à côte :

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  📊 Comparateur de rentabilité — Sur place                    [Canal: ▼]    │
│                                                                              │
│  ┌──────────────────┬────────┬────────┬────────┬────────┬────────┐          │
│  │ Produit          │ PV TTC │ Coût   │ Ratio  │ Coeff. │ Marge  │          │
│  ├──────────────────┼────────┼────────┼────────┼────────┼────────┤          │
│  │ Riz Sauté Poulet │ 12,90€ │ 1,44€  │ 12,3%  │ ×8,14  │ 10,29€ │          │
│  │ Bo bun Poulet    │ 12,90€ │ 1,82€  │ 15,5%  │ ×6,45  │ 9,91€  │          │
│  │ Phried Rice Poulet│12,90€ │ 1,53€  │ 13,0%  │ ×7,66  │ 10,20€ │          │
│  │ Curry boulettes  │ 12,90€ │ 2,10€  │ 17,9%  │ ×5,59  │ 9,63€  │          │
│  │ Crazy Tenders    │ 12,90€ │ 1,95€  │ 16,6%  │ ×6,02  │ 9,78€  │          │
│  └──────────────────┴────────┴────────┴────────┴────────┴────────┘          │
│                                                                              │
│  Moyenne ratio : 15,1%  │  [+ Ajouter un produit]  [Exporter PDF]          │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Fonctionnalités du comparateur :**
- Sélection de produits par recherche ou catégorie
- Filtrage par canal (sur place / emporter / livraison)
- Tri par ratio, marge, coefficient ou coût
- Moyenne affichée pour le groupe sélectionné
- Export PDF pour archivage ou discussion en réunion

**Workflow intégré (remplace le Google Sheets) :**
```
1. L'admin crée/modifie une recette → coût matière calculé automatiquement ✅
2. Il ouvre l'onglet "Rentabilité" de la fiche recette
3. Il saisit/ajuste les prix TTC par canal ← (seule saisie manuelle)
4. Il voit instantanément ratios, coefficients, marges par canal et variante
5. Il compare avec d'autres produits via le comparateur
6. Il valide le prix → prêt pour la mise en carte
```

> **Gain vs workflow actuel :** Plus besoin de calculer le coût dans inpulse puis de le copier dans un Google Sheets. Le coût est toujours à jour (mis à jour auto à chaque BDL), les ratios se recalculent en temps réel, et la comparaison avec les autres produits est intégrée.

### 5.5 Décrémentation des stocks

**Fonctionnement :**
1. Zelty envoie les ventes en temps réel (ou par polling régulier via API)
2. Pour chaque produit vendu, le système :
   - Récupère la recette associée
   - Décrémente le stock de chaque ingrédient restaurant selon la quantité définie dans la recette
   - Met à jour le stock théorique
3. Les stocks sont incrémentés UNIQUEMENT à la validation du contrôle BL (pas avant)

**Logique d'incrémentation des stocks à réception :**
```
1. Livraison reçue → l'opérateur ouvre le contrôle (stocks PAS encore incrémentés)
2. Photo BL → IA compare avec BC → pré-validation en bloc
3. L'opérateur ne traite que les écarts signalés par l'IA
4. Validation du contrôle → stocks incrémentés selon les quantités acceptées :
   - Ligne conforme → stock incrémenté de la quantité livrée
   - Quantité inférieure → stock incrémenté de la quantité réelle
   - Produit manquant → stock non incrémenté
   - Substitution frais/surgelé → acceptée, stock de l'ingrédient original incrémenté
     → anomalie tracée + photo + demande d'avoir sous 72h max
```

**Calcul du stock :**
```
stock_actuel = stock_précédent
             + quantités_reçues (réception commandes)
             - quantités_vendues (décrémentation Zelty)
             - pertes (saisie manuelle, V2)
             +/- ajustements_inventaire (écarts inventaire physique)
```

### 5.5b Calcul du coût matière — source de prix

**Constat inpulse.ai :** Inpulse proposait un système de sélection de "sources de coût" par fournisseur (`isUsedForCost`), permettant de choisir un ou plusieurs fournisseurs pour calculer le coût moyen d'un ingrédient. En pratique, ce système était trop complexe à maintenir — 354 sur 355 associations étaient laissées à "activé", rendant le calcul peu fiable. 56 ingrédients avaient de vrais fournisseurs multiples.

**Approche PhoodApp : simple et automatique**

PhoodApp remplace ce système par un mécanisme automatisé basé sur le **fournisseur préféré** :

```
Coût unitaire ingrédient = prix_unitaire_ht du fournisseur préféré
                         ÷ facteur_conversion (pour normaliser en unité_stock)
                         ÷ rendement (si applicable)
```

**Règles de calcul :**

1. **Source par défaut** : `prix_unitaire_ht` du fournisseur préféré dans la mercuriale
2. **Mise à jour automatique** : à chaque contrôle BDL validé, si le prix réel diffère du prix mercuriale, le prix mercuriale ET le coût unitaire sont mis à jour automatiquement (avec traçabilité dans `historique_prix`)
3. **Changement de source** : pour changer la source de coût, l'admin change le `fournisseur_prefere_id` de l'ingrédient restaurant → le coût se recalcule instantanément
4. **Propagation** : tout changement de coût unitaire recalcule automatiquement le `cout_matiere` de toutes les recettes utilisant cet ingrédient (récursivement à travers les sous-recettes)

**Conversion d'unités :**
Le prix fournisseur est exprimé en unité de commande (ex: €/sac de 25kg). Le coût unitaire est normalisé en unité de stock de l'ingrédient restaurant (ex: €/kg) :

```
Exemple : Oignons Jaunes
├── Fournisseur préféré : Promocash Bordeaux
├── Prix mercuriale : 1.29€ / sac de 25kg
├── Prix par kg : 1.29 ÷ 25 = 0.0516 €/kg
├── Rendement : 0.90 (10% d'épluchage)
└── Coût unitaire final : 0.0516 ÷ 0.90 = 0.0573 €/kg
```

**Chaîne de calcul du coût matière d'un produit vendu :**
```
Produit vendu (ex: Bo bun poulet)
├── Ingrédient 1 : 0.150 kg poulet × 7.40 €/kg = 1.110€
├── Ingrédient 2 : 0.100 kg vermicelles × 2.50 €/kg = 0.250€
├── Sous-recette : 0.050 kg sauce nuoc mam
│   ├── Sous-ingrédient A : ...€
│   └── Sous-ingrédient B : ...€
│   = 0.180€
├── ...
= Coût matière total : 2.85€
÷ Prix vente TTC : 12.90€
= Ratio coût matière : 22.1%
```

**Dashboard comparatif multi-fournisseur (V1) :**
Pour chaque ingrédient, la fiche affiche un tableau comparatif de tous les fournisseurs disponibles :

| Fournisseur | Référence | Cond. | Prix | Prix/kg | Écart vs préféré | Dernière livraison |
|---|---|---|---|---|---|---|
| ⭐ Promocash | Oignons 25kg | 25 kg | 1.29€ | 0.052€ | — | 02/03/2026 |
| Transgourmet | Oignons kg | 1 kg | 0.39€ | 0.390€ | +650% | 15/02/2026 |
| Mungoo | Oignons | 1 kg | 0.99€ | 0.990€ | +1804% | 28/02/2026 |
| One Move | Oignons 5kg | 5 kg | 2.50€ | 0.500€ | +862% | — |

> ⭐ = fournisseur préféré (source du coût matière). Cliquer sur un autre fournisseur pour le définir comme préféré.

**Alerte variation de prix :**
- Si le prix reçu sur un BDL dépasse ±10% du prix mercuriale → alerte orange dans le contrôle
- L'opérateur peut accepter (→ prix mercuriale mis à jour) ou signaler une erreur (→ demande d'avoir)
- Seuil configurable par catégorie (ex: ±5% surgelés, ±20% fruits/légumes frais)

**Différences clés avec inpulse.ai :**

| Aspect | Inpulse | PhoodApp |
|---|---|---|
| Source de coût | Sélection manuelle `isUsedForCost` par fournisseur | Automatique = fournisseur préféré |
| Calcul multi-source | Moyenne pondérée (si plusieurs sources cochées) | Pas de moyenne — 1 seule source, la préférée |
| Mise à jour | Manuelle (modifier les prix dans l'interface) | Automatique à chaque réception BDL |
| Changement de source | Cocher/décocher `isUsedForCost` par fournisseur | Changer `fournisseur_prefere_id` (1 clic) |
| Comparaison prix | Non visible | Dashboard comparatif sur la fiche ingrédient |

### 5.6 Migration des données depuis inpulse.ai

**Problème identifié :** Inpulse ne propose pas d'export natif des recettes ni des ingrédients.

**Solution retenue : Extraction via API interne (Deepsight)**

L'analyse du code source d'inpulse.ai a révélé une API REST interne exploitable :

| Endpoint | Données | Volume |
|---|---|---|
| `GET /v2/recipes` | Recettes avec composants (mappings), sous-recettes, liens produits caisse | 783 |
| `GET /v2/ingredients/{id}` | Ingrédients avec produits fournisseur (SKU, prix, conditionnement, fournisseur, allergènes) | 424 |
| `GET /v2/suppliers` | Fournisseurs (nom, adresse, contact, email, téléphone) | 81 |
| `GET /v2/categories` | Catégories et sous-catégories | toutes |

**API technique :**
- Base URL : `https://api.deepsight.io`
- Auth : Token LoopBack 64 chars (header `Authorization`)
- Token source : `localStorage.loopbackAccessToken`
- Format : JSON REST

**Export réalisé le 05/03/2026 :** fichier `inpulse_export_phood.json` (7.77 MB) contenant l'intégralité des données.

**Stratégie d'import dans PhoodApp :**
1. **Script de migration** : Parse du JSON exporté → mapping vers le modèle Supabase
2. **Correspondances à établir** :
   - Recettes inpulse (`isIngredient: false`) → table `recettes`
   - Ingrédients inpulse (`isIngredient: true` dans `/v2/ingredients`) → table `ingredients_restaurant`
   - Supplier products (imbriqués dans chaque ingrédient) → table `ingredients_fournisseur`
   - Mappings recette↔ingrédient (via `childEntityId`/`parentEntityId`) → table `recette_ingredients`
   - Catégories → table `categories`
3. **Sous-recettes** : Détectées via `lnkEntityEntitymappingrel.isIngredient === false` dans les mappings
4. **Validation** : Interface de revue post-import pour vérifier les données migrées
5. **Données NON migrées** : Historique commandes (repart de zéro), historique ventes (import via Zelty API)

---

## 6. Module 4 : Inventaire physique

### 6.1 Principe

L'inventaire physique permet de compter manuellement les stocks réels et de les comparer au stock théorique calculé par le système.

### 6.2 Zones de stockage

Le restaurant dispose de **4-5 zones de stockage** physiques. Chaque zone est configurable par l'admin :

| Zone | Description | Exemples d'ingrédients |
|---|---|---|
| Chambre froide positive | Produits frais (2-4°C) | Viandes, légumes, produits laitiers |
| Chambre froide négative | Produits surgelés (-18°C) | Nems, surgelés, glaces |
| Réserve sèche | Produits d'épicerie, conserves | Sauces, épices, riz, nouilles |
| Bar / Boissons | Boissons, café, thé | Coca, bières, café |
| Autre (optionnel) | Zone supplémentaire si nécessaire | Consommables, emballages |

Chaque ingrédient fournisseur est rattaché à une zone de stockage. Ce rattachement sert à organiser les inventaires par zone.

### 6.3 Modèles d'inventaires

Les modèles d'inventaires sont des templates pré-configurés qui définissent la liste des ingrédients à compter :

| Modèle | Contenu | Usage |
|---|---|---|
| Inventaire complet | Tous les ingrédients de toutes les zones | Inventaire mensuel / bi-mensuel |
| Inventaire par zone | Ingrédients d'une zone spécifique | Inventaire partiel rapide (ex: bar seulement) |

**Configuration des modèles (Admin) :**
- Créer/modifier des modèles d'inventaire
- Sélectionner les ingrédients inclus (par zone ou manuellement)
- Choisir les conditionnements disponibles pour le comptage (basé sur `utilise_inventaire` des conditionnements)
- Un ingrédient peut avoir plusieurs conditionnements d'inventaire (ex: compter en "sacs de 1.9kg" ET en "unités")

### 6.4 Processus d'inventaire

```
1. L'opérateur crée un nouvel inventaire :
   - Sélection du modèle d'inventaire (complet ou par zone)
   - Date de l'inventaire
2. Le système affiche la liste des ingrédients du modèle, organisés par zone :
   - Nom de l'ingrédient
   - Conditionnement(s) de comptage disponibles
   - Unité de stock
   - Stock théorique actuel (masquable pour éviter le biais)
3. L'opérateur saisit les quantités réelles :
   - Choix du conditionnement de comptage (ex: "3 sacs de 1.9kg + 12 unités")
   - Le système convertit automatiquement en unité de stock
4. Auto-save permanent
5. À la validation, le système calcule :
   - Écart par ingrédient (réel - théorique)
   - Écart en valeur (€)
   - % d'écart
6. Le stock théorique est recalé sur le stock réel
7. L'inventaire est archivé pour historique
```

### 6.5 Interface inventaire (iPad-first)

- Liste scrollable des ingrédients par zone de stockage (accordion par zone)
- Champ numérique large avec clavier numérique natif
- Boutons +/- pour ajustement rapide
- Sélecteur de conditionnement si plusieurs disponibles
- Possibilité de scanner (futur) ou rechercher un ingrédient
- Indicateur visuel quand un écart est important (> seuil paramétrable)
- Navigation rapide entre zones (onglets ou scroll ancré)

---

## 7. Module 5 : Prévision des ventes et aide à la commande

### 7.1 Sources de données pour la prévision

| Source | Données | Usage |
|---|---|---|
| **Zelty** (historique) | Ventes par produit, par jour, par heure | Base historique |
| **API Météo** | Température, pluie, ensoleillement (prévisions J+7) | Corrélation météo/CA |
| **Événements** | Jours fériés, vacances scolaires, matchs, festivals locaux | Impact événementiel |
| **Facteurs custom** | Travaux à côté, fermeture concurrent, promotions, etc. | Facteurs spécifiques au restaurant |

### 7.2 Modèle de prévision

**Approche V1 (pragmatique) :**

```
prevision_jour(J) =
    base_historique(J)
  × coefficient_meteo(J)
  × coefficient_rupture_meteo(J)
  × coefficient_evenement(J)
  × coefficient_tendance_recente(7_derniers_jours)
  × coefficient_facteur_custom(J)
```

**Calcul de la base historique — comparaison par jour de semaine, pas par date calendaire :**

Le système compare TOUJOURS par **jour de semaine équivalent**, jamais par numéro de date :
- Pour prévoir le mardi 3 février 2026, on regarde le **mardi le plus proche du 3 février 2025** (pas le 3 février 2025 qui était un lundi)
- Concrètement : on aligne les semaines par numéro de semaine ISO et par jour de semaine
- Exemple : semaine 5 mardi 2026 → comparé à semaine 5 mardi 2025

```
base_historique(J) = moyenne_ponderee(
    CA du même jour_semaine des 4 dernières semaines comparables,
    CA du jour_semaine équivalent N-1
)
```

**Gestion des événements mobiles (vacances, fériés, soldes) :**

Les vacances scolaires, certains jours fériés (Pâques, Ascension...) et les soldes ne tombent PAS aux mêmes dates chaque année. Le modèle doit en tenir compte :

1. **Jours fériés mobiles** (Pâques, Ascension, Pentecôte, etc.) :
   - Le système connaît les dates exactes année par année
   - La comparaison N-1 d'un jour férié se fait avec le **même jour férié N-1** (pas la même date)
   - Ex: Lundi de Pâques 2026 (6 avril) comparé au Lundi de Pâques 2025 (21 avril), pas au 6 avril 2025

2. **Vacances scolaires** :
   - Les dates changent chaque année (décalées de 1-2 semaines)
   - Le coefficient "vacances" est appliqué en fonction du **calendrier réel de chaque année**
   - La comparaison N-1 d'une semaine de vacances se fait avec la **semaine équivalente des vacances N-1** (ex: 1ère semaine vacances février 2026 → 1ère semaine vacances février 2025)

3. **Soldes** :
   - Dates officielles connues à l'avance, varient légèrement chaque année
   - Même logique : comparer semaine 1 des soldes 2026 avec semaine 1 des soldes 2025

**Coefficients :**
- `coefficient_meteo` : basé sur la corrélation historique météo/CA (voir calibrage ci-dessous)
- `coefficient_rupture_meteo` : coefficient d'amortissement lors d'un changement brutal de météo après une période stable (voir calibrage ci-dessous)
- `coefficient_evenement` : défini par type d'événement, calibré sur l'historique quand disponible (ex: "vacances_scolaires" = 1.3 par défaut)
- `coefficient_tendance_recente` : rapport entre les 7 derniers jours et la même période historique (capte la tendance court terme)
- `coefficient_facteur_custom` : saisi manuellement par le manager

**Calibrage météo spécifique (centre commercial Bègles) :**

Le restaurant est situé en centre commercial. Le comportement est INVERSE d'un restaurant de rue :

| Condition météo | Impact sur place (midi) | Impact emporter | Impact livraison |
|---|---|---|---|
| Pluie / mauvais temps | **Forte hausse** (les gens viennent au centre commercial) | Baisse légère | Hausse légère |
| Beau temps / soleil | **Baisse** (les gens sortent, ne viennent pas au CC) | Hausse | Stable/faible |
| Froid modéré | **Hausse** (CC chauffé, refuge) | Variable | Variable |
| Froid extrême (bien en dessous des normales saisonnières) | **Atténué** → les gens restent chez eux | Baisse | Variable |
| Chaud modéré | Baisse (les gens sortent) | Hausse | Stable |
| Canicule (bien au dessus des normales saisonnières) | **Atténué** → apathie générale, moins de consommation malgré la clim du CC | Baisse | Baisse |

Ces coefficients devront être calibrés sur les données historiques Zelty croisées avec les données météo passées.

**Effet des températures extrêmes (non-linéarité) :**

La relation entre température et fréquentation n'est **PAS linéaire**. Elle suit une courbe en cloche inversée pour un centre commercial :

```
Fréquentation CC (sur place)
      │
  ↑↑  │        ╭──╮                    ╭──╮
  ↑   │      ╭─╯  ╰─╮              ╭─╯  ╰─╮
      │    ╭─╯      ╰─╮          ╭─╯      ╰─╮
  ──  │───╯            ╰────────╯            ╰───
  ↓   │
  ↓↓  │
      └──────────────────────────────────────────── Température
       Très froid   Froid    Doux   Chaud   Canicule
       (extrême)  (refuge CC)     (dehors)  (apathie)
```

- **Zone "refuge"** (froid modéré, pluie) : les gens fuient le mauvais temps → hausse CC
- **Zone "confort"** (doux, beau) : les gens profitent du dehors → baisse CC
- **Zone "extrême"** (grand froid, canicule) : les gens deviennent inactifs, restent chez eux → **atténuation du bénéfice CC** malgré la clim/le chauffage. L'apathie générale réduit la consommation

Le modèle doit capturer cette **non-linéarité** en comparant les températures du jour aux **normales saisonnières** (pas aux valeurs absolues) :

```
Calcul de l'écart aux normales :
  ecart_temperature(J) = temperature_jour(J) - normale_saisonniere(J)

Normales saisonnières : moyenne glissante sur 30 ans (Open-Meteo Archive)
ou à défaut : moyenne des mêmes jours sur l'historique disponible (12-18 mois)

Seuils d'extrême :
  - Froid extrême : ecart_temperature < -seuil_ecart (ex: -8°C sous la normale)
  - Canicule : ecart_temperature > +seuil_ecart (ex: +8°C au-dessus de la normale)
```

**Calibrage de l'effet extrême (à l'import initial) :**

```
Pour chaque jour de l'historique :
  1. Calculer l'écart aux normales saisonnières
  2. Classifier : froid_extreme / froid_modere / doux / chaud / canicule
  3. Pour chaque classe, calculer le ratio CA_reel / CA_attendu
  4. En déduire le coefficient par classe de température
```

**Intégration dans le coefficient_meteo :**

Le `coefficient_meteo` existant intègre déjà la température. L'ajustement consiste à le rendre non-linéaire :

```
coefficient_meteo(J) =
    coefficient_precipitation(J)      — pluie/soleil (corrélation inversée CC)
  × coefficient_temperature(J)        — NON-LINÉAIRE : atténuation aux extrêmes
```

Avec `coefficient_temperature` qui suit la courbe en cloche :
- Froid extrême (< normale - seuil) : coefficient < 1.0 (atténuation, ex: 0.85)
- Froid modéré : coefficient > 1.0 (hausse, ex: 1.10)
- Doux / confort : coefficient = 1.0 (baseline)
- Chaud : coefficient < 1.0 (baisse légère)
- Canicule (> normale + seuil) : coefficient < 1.0 (atténuation forte, ex: 0.80)

**Seuils configurables (admin) :**

| Paramètre | Défaut | Description |
|---|---|---|
| `extreme_seuil_ecart_degres` | 8.0 | Écart minimum par rapport à la normale saisonnière pour déclencher l'effet "extrême" (°C) |
| `extreme_coefficient_froid` | À calibrer | Coefficient appliqué en cas de froid extrême |
| `extreme_coefficient_canicule` | À calibrer | Coefficient appliqué en cas de canicule |

**Affichage dans les prévisions :**
- Quand un extrême de température est détecté, une icône 🥶 ou 🔥 et un tooltip : "Température extrême : +10°C au-dessus des normales. Atténuation fréquentation : -15%"

**Effet de rupture météo (acclimatation) :**

Observation terrain : après une période de météo stable (ex : 4-5 jours de pluie consécutifs), un changement brutal (beau temps soudain) provoque une **chute temporaire de fréquentation** le(s) premier(s) jour(s), avant un retour à la normale. Les clients ont besoin d'un temps d'acclimatation pour changer leurs habitudes.

Ce phénomène est spécialement marqué en centre commercial (les clients habituels de la période de pluie ne viennent plus, et les clients de beau temps n'ont pas encore repris le réflexe).

```
Détection d'une rupture météo :
1. Identifier les "périodes stables" : N jours consécutifs de météo similaire
   - Critère pluie : precipitation_sum > seuil_pluie pendant N jours
   - Critère beau temps : sunshine_duration > seuil_soleil ET precipitation_sum < seuil_sec pendant N jours
   - N minimum configurable (défaut : 3 jours consécutifs)

2. Détecter la transition : le jour J rompt la série stable
   - Transition "pluie → beau temps" : période pluie ≥ N jours, puis J = beau temps
   - Transition "beau temps → pluie" : période beau temps ≥ N jours, puis J = pluie

3. Appliquer un coefficient d'amortissement :
   - Jour J (rupture) : coefficient_rupture = valeur calibrée (ex: 0.85 = -15%)
   - Jour J+1 : coefficient atténué (ex: 0.93 = -7%)
   - Jour J+2+ : coefficient = 1.0 (retour à la normale)
```

**Calibrage de l'effet de rupture (à l'import initial) :**

Le calibrage est automatique, basé sur le croisement des données historiques :

```
Pour chaque jour de l'historique (CA Zelty + météo Open-Meteo Archive) :
  1. Calculer la "série météo" des jours précédents (pluie/soleil/neutre)
  2. Identifier les jours de rupture (transition après ≥ N jours stables)
  3. Pour chaque rupture trouvée :
     - Calculer l'écart entre le CA réel et le CA attendu (moyenne du même jour de semaine)
     - Regrouper par type de transition (pluie→soleil, soleil→pluie)
     - Regrouper par durée de la période stable précédente (3j, 4j, 5j+)
  4. En déduire les coefficients moyens par type de transition et durée
```

**Résultats attendus du calibrage :**

| Type de transition | Durée période stable | Coefficient J (rupture) | Coefficient J+1 |
|---|---|---|---|
| Pluie → Beau temps | 3 jours | À calibrer (~0.80-0.90) | À calibrer (~0.90-0.95) |
| Pluie → Beau temps | 5+ jours | À calibrer (~0.75-0.85) | À calibrer (~0.85-0.95) |
| Beau temps → Pluie | 3 jours | À calibrer (~0.90-1.00) | ~1.0 |
| Beau temps → Pluie | 5+ jours | À calibrer (~0.85-0.95) | ~1.0 |

Les coefficients réels seront remplis par l'analyse de l'historique. Si l'effet n'est pas statistiquement significatif (trop peu d'occurrences ou écarts faibles), le coefficient reste à 1.0 (aucun impact).

**Affichage dans les prévisions :**
- Quand une rupture météo est détectée dans les prévisions J+7, une icône ⚡ et un tooltip expliquent l'ajustement : "Rupture météo : transition pluie → soleil après 5 jours de pluie. Coefficient d'amortissement : -12%"
- Le détail est visible dans le panneau expandable du jour

**Seuils configurables (admin) :**

| Paramètre | Défaut | Description |
|---|---|---|
| `rupture_jours_minimum` | 3 | Nombre minimum de jours stables avant qu'une transition soit considérée comme "rupture" |
| `rupture_seuil_pluie_mm` | 1.0 | Seuil de précipitations (mm/jour) pour qualifier un jour de "pluie" |
| `rupture_seuil_soleil_heures` | 6.0 | Seuil d'ensoleillement (heures/jour) pour qualifier un jour de "beau temps" |
| `rupture_duree_amortissement` | 2 | Nombre de jours d'amortissement après la rupture (J et J+1 par défaut) |

**Évolution V2+ :** Remplacement par un modèle ML plus sophistiqué si les données le permettent.

### 7.3 Événements et facteurs custom

**Interface de gestion des événements :**

| Champ | Type | Description |
|---|---|---|
| `date` | date | Date de l'événement |
| `type` | string | Type (ferie, vacances_scolaires, soldes, match, festival, travaux, promo, fermeture, custom) |
| `source` | string | "auto" (calendrier officiel) ou "manuel" (saisi par l'utilisateur) |
| `nom` | string | Description (ex: "Match Bordeaux - PSG") |
| `impact_ca` | number | Coefficient d'impact estimé (ex: 1.2 = +20%, 0.8 = -20%) |
| `recurrent` | boolean | Se répète chaque année ? |

**Événements automatiques (pré-remplis) :**

Le système intègre automatiquement les calendriers suivants au lancement :

| Calendrier | Source technique | Méthode | Impact typique (centre commercial) |
|---|---|---|---|
| **Jours fériés français** | Calcul local (~40 lignes JS) | 11 jours fixes (1er janvier, 1er mai, etc.) + jours mobiles via algorithme de Meeus/Jones/Butcher pour Pâques → Ascension, Pentecôte, Lundi de Pâques. Généré au démarrage pour N et N+1 | Variable : certains fériés = forte affluence (ponts), d'autres = fermeture |
| **Vacances scolaires** | API `data.education.gouv.fr` | Endpoint REST officiel, filtré par **Zone A** (académie Bordeaux). Données disponibles pour N et N+1. Rafraîchissement : 1 appel/an (ou au démarrage). Format JSON avec dates début/fin par période | Forte hausse d'affluence au centre commercial |
| **Périodes de soldes** | Calcul local + table d'override | Soldes d'hiver : 2ème mercredi de janvier (sauf si après le 12 → mercredi précédent). Soldes d'été : dernier mercredi de juin. Durée : 4 semaines. Override possible en base (dates préfectorales ou exceptions) | Forte hausse d'affluence au centre commercial |

**Stockage :** Les événements automatiques sont générés et insérés dans la table `evenements` avec `source = 'auto'`. Régénération automatique chaque année (ou au premier accès de l'année).

Chaque événement automatique a un **coefficient d'impact par défaut** modifiable par l'admin. Ces coefficients s'affinent avec le temps grâce à la comparaison prévision vs réalisé.

**Événements manuels :**
- L'opérateur peut ajouter un événement pour un jour donné (bouton "+")
- Types : match sportif, festival, travaux, promo, fermeture concurrent, custom
- Les événements sportifs (Top 14, Ligue 1, etc.) sont saisis manuellement — pas d'intégration API sportive (impact faible sur le CA en centre commercial)

**Jours de fermeture :**
- Les jours de fermeture du restaurant sont VARIABLES (lié aux horaires du centre commercial)
- **Source de vérité : la fiche Google Business Profile** du restaurant
- Synchronisation automatique des horaires depuis l'API Google Business Profile
- Les horaires exceptionnels (fermetures ponctuelles) sont aussi récupérés
- Les jours de fermeture sont exclus des prévisions (CA = 0)
- Impact sur la recommandation de commande : pas de consommation prévue les jours fermés
- Fallback : l'admin peut saisir manuellement des fermetures si la fiche Google n'est pas à jour

### 7.4 Interface prévisions de CA

**Vue semaine (écran principal des prévisions) :**
```
┌────────────────────────────────────────────────────────────────────┐
│  Précision S-1: 92%  │  CA TTC réalisé S-1: 13 414€  │  CA prévu │
│                      │         -2%                     │  13 959€  │
│                      │                                 │    +17%   │
├────────────────────────────────────────────────────────────────────┤
│  Lun 23    Mar 24    Mer 25    Jeu 26    Ven 27    Sam 28   Dim 1 │
│  ☁️ 15|10   🌧️ 19|10  🌧️ 19|12  ☁️ 17|11  ☀️ 16|10  ☀️ 15|10  ☀️15|9│
│                                                                    │
│  [2103]     [2007]    [2003]    [2219]    [2455]    [3171]   [0]   │
│   1639      2653      2436      2470      2707      3577     -     │
│                                                                    │
│                                          Top 14    Ligue 1         │
│                                          [+]       [+]             │
└────────────────────────────────────────────────────────────────────┘
```

- **Icône météo + températures min/max** par jour (prévision Open-Meteo)
- **Prévision CA** (vert, encadré) vs **réalisé année passée** (gris) par jour
- **Événements** affichés sous le jour concerné
- Bouton **+** pour ajouter un événement
- Navigation par flèches (semaine précédente/suivante)
- **Graphique tendance** : barres comparant tendance vs année passée, avec moyenne

#### Contexte N-1 (V1)

Sous chaque jour de la vue prévisions, un **panneau expandable** (chevron ▼) affiche le contexte du jour équivalent N-1 :

```
▼ Contexte N-1 : Mardi 25/03/2025
┌─────────────────────────────────────────┐
│  🌧️ 14°C / 8°C — Pluie (12mm)          │
│  📅 Vacances scolaires zone A           │
│  💰 CA réalisé : 2 436€ (87 tickets)    │
│  📊 Écart vs prévision N-1 : +4%        │
└─────────────────────────────────────────┘
```

**Logique de correspondance N-1 :**
- Comparaison par **jour de semaine** équivalent (mardi vs mardi), PAS par date calendaire
- Pour les événements mobiles (Pâques, vacances scolaires) : comparer avec le jour N-1 qui avait le même événement
- Données affichées : météo réelle N-1 (Open-Meteo Archive), événements N-1, CA réalisé N-1 (Zelty), écart prévision vs réalisé N-1

**Source des données :**
- Météo N-1 : table `meteo_daily` (importée via Open-Meteo Archive API, one-shot initial)
- CA N-1 : table `ventes_historique` (importée via Zelty API, one-shot initial)
- Événements N-1 : table `evenements` (calendriers automatiques + saisie manuelle)

**Import météo historique :** Au déploiement, un script one-shot récupère toute la météo disponible (même profondeur que le CA Zelty, ~18 mois minimum) via un seul appel à `archive-api.open-meteo.com`. Gratuit, pas de clé API nécessaire.

### 7.5 Aide à la commande

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
│ Dernière commande : 24/02 - 15 kg - 4.50€/kg           │
│ Prix actuel : 4.65€/kg (+3.3%)                          │
└─────────────────────────────────────────────────────────┘
```

### 7.6 Répartition horaire du CA (fine-tuning)

Le modèle de prévision (section 7.2) donne un **CA journalier**. Pour descendre au niveau horaire, on calcule une **courbe de répartition type** à partir de l'historique des tickets Zelty (qui sont horodatés).

```
Calcul de la courbe (calibrage initial + mise à jour continue) :

Pour chaque jour_de_semaine (lundi..dimanche) :
  Pour chaque créneau horaire (10h-11h, 11h-12h, ... 21h-22h) :
    repartition[jour][creneau] =
      somme(CA du créneau sur les N dernières semaines)
      / somme(CA total du jour sur les N dernières semaines)

Résultat : une matrice 7 jours × 12 créneaux (10h-22h)
```

**Exemple résultat — Mardi type :**
```
10h-11h :  3%  │░
11h-12h : 12%  │████
12h-13h : 28%  │██████████
13h-14h : 22%  │████████
14h-15h :  5%  │██
15h-16h :  2%  │░
16h-17h :  1%  │
17h-18h :  2%  │░
18h-19h :  5%  │██
19h-20h : 10%  │████
20h-21h :  7%  │███
21h-22h :  3%  │░
```

**Prédiction CA par créneau :**
```
ca_prevu_creneau(jour, heure) =
    ca_prevu_jour(jour)                       ← modèle prévision existant (section 7.2)
  × repartition_horaire[jour_semaine][heure]  ← courbe type calculée ci-dessus
```

Exemple : mardi prochain → CA prévu 2 450€ × 28% (12h-13h) = **686€ prévus entre 12h et 13h**

**Variantes contextuelles :** Les courbes peuvent varier selon le contexte (vacances scolaires, week-end, événement). Le système calcule des courbes spécifiques si suffisamment de données historiques :
- Courbe jour de semaine hors vacances (défaut)
- Courbe jour de semaine en vacances
- Courbe samedi
- Courbe dimanche
- Si pas assez de données pour une variante → fallback sur la courbe jour de semaine générique

**Utilité :** Ces données de répartition horaire servent à affiner les prévisions de consommation par créneau, comprendre les pics d'activité, et préparer les services (prep en cuisine, staffing). Elles sont stockées dans la table `repartition_horaire` (7 jours × 12 créneaux = 84 entrées).

---

## 7b. Module 5b : Rapprochement des factures fournisseurs

### 7b.1 Principe

Les factures fournisseurs arrivent sur PennyLane (logiciel comptable). Le système récupère les factures via l'API PennyLane et les rapproche automatiquement avec les bons de livraison et les avoirs déjà enregistrés.

### 7b.2 Flux des factures

```
[Fournisseur envoie facture par email]
     |
     v
[PennyLane reçoit et enregistre la facture]
     |
     v
[PhoodApp récupère la facture via API PennyLane] ← polling toutes les heures
     |
     v
[Matching automatique : facture ↔ BL(s) correspondant(s)]
     |
     ├── Match trouvé → Rapprochement automatique
     |     |
     |     ├── Facture = BL - avoirs → ✅ Conforme
     |     |
     |     └── Facture ≠ BL - avoirs → ⚠️ Écart détecté
     |           |
     |           v
     |     [Alerte Admin avec détail des écarts]
     |           ├── Lignes avec écart de quantité
     |           ├── Lignes avec écart de prix
     |           ├── Avoir non déduit
     |           └── Ligne non reconnue
     |
     └── Pas de match
           |
           ├── Catégorie PennyLane = "matières premières"
           |     → 🛒 **Achat hors commande (dépannage)** détecté
           |     → Notification Admin
           |     → Impacte le coût matière réel
           |
           └── Autre catégorie → ⚠️ Facture orpheline (alerte Admin)
```

### 7b.3 Achats hors commande (dépannage)

Il arrive que des achats soient effectués en dépannage (achat direct en magasin, marché, etc.) sans passer par le logiciel de commande. Ces achats n'ont **pas de BC** dans PhoodApp mais génèrent une **facture dans PennyLane**.

**Détection automatique :**
```
[PhoodApp récupère facture via PennyLane API]
     |
     v
[Tentative de matching avec un BC existant]
     |
     └── Pas de BC trouvé
           + Catégorie PennyLane = "matières premières"
           → ACHAT HORS COMMANDE DÉTECTÉ
           → Notification Admin dans le dashboard
```

**Critères d'identification :**
- Catégorie PennyLane = "matières premières" (ou catégorie configurée par l'admin)
- ET aucun BC correspondant dans PhoodApp (pas de matching possible)

**Traitement par l'admin :**

Le système propose deux niveaux de traitement :

1. **Impact global seulement** (par défaut, rapide) :
   - Le montant HT de la facture est ajouté au coût matière réel de la période
   - Pas de ventilation par ingrédient
   - Le fournisseur est identifié (connu ou ponctuel)
   - Suffisant pour la fiabilité du coût matière %

2. **Ventilation par ingrédient** (optionnel, pour la précision) :
   - L'admin peut associer chaque ligne de la facture à un ingrédient fournisseur
   - Si le fournisseur est déjà dans PhoodApp → suggestion automatique des ingrédients par matching nom/référence
   - Si fournisseur ponctuel (supermarché, marché) → association manuelle aux ingrédients restaurant
   - Impact : stock théorique incrémenté + coût matière réel + historique achats par ingrédient

**Fournisseurs ponctuels :**
- Si la facture provient d'un fournisseur non référencé dans PhoodApp (supermarché, marché, etc.), il n'est pas nécessaire de créer une fiche fournisseur complète
- Le fournisseur est identifié par son nom PennyLane et rattaché à la facture
- Les achats ponctuels sont tagués "dépannage" pour les distinguer dans les analyses

**Données d'un achat hors commande :**

| Champ | Type | Description |
|---|---|---|
| `id` | string | Identifiant unique |
| `facture_id` | string | Lien vers la facture PennyLane |
| `fournisseur_nom` | string | Nom du fournisseur (PennyLane) |
| `fournisseur_id` | string | Lien fournisseur PhoodApp si connu, null sinon |
| `date_achat` | date | Date de la facture |
| `montant_ht` | number | Montant HT total |
| `montant_tva` | number | Montant TVA |
| `ventilation` | array | Optionnel : [{ingredient_id, quantite, prix_ht}] si ventilé |
| `statut` | string | "non_traite" / "global" / "ventile" |
| `notes` | string | Commentaire libre (ex: "rupture Transgourmet, dépannage Promocash cash&carry") |

**Impact sur les KPIs :**
- **Coût matière réel** : TOUJOURS impacté (montant HT ajouté à la période)
- **Stock théorique** : Impacté SEULEMENT si ventilé par ingrédient
- **Analyse achats par produit** : Impacté SEULEMENT si ventilé
- **Analyse achats par fournisseur** : TOUJOURS impacté (même fournisseur ponctuel)

### 7b.4 Rapprochement facture vs BL + avoirs

**Logique de rapprochement :**

```
montant_attendu = total_BL_validé - total_avoirs_acceptés

SI facture == montant_attendu → CONFORME
SI facture != montant_attendu → ÉCART
    → détail ligne par ligne
    → alerte Admin
```

**Matching facture ↔ BL :**
- Par numéro de commande (BC) si présent sur la facture
- Par fournisseur + date de livraison
- Par montant global si les autres critères ne matchent pas
- L'IA (OpenAI) peut aider à extraire les données de la facture PDF si nécessaire

### 7b.4 Données facture

| Champ | Type | Description |
|---|---|---|
| `id` | string | Identifiant unique |
| `pennylane_id` | string | ID de la facture dans PennyLane |
| `fournisseur_id` | string | Lien vers le profil fournisseur |
| `numero_facture` | string | Numéro de facture fournisseur |
| `date_facture` | date | Date de la facture |
| `date_echeance` | date | Date d'échéance de paiement |
| `montant_ht` | number | Montant HT |
| `montant_tva` | number | Montant TVA |
| `montant_ttc` | number | Montant TTC |
| `bl_associes` | array | BL liés à cette facture |
| `avoirs_associes` | array | Avoirs déduits |
| `statut_rapprochement` | string | conforme / ecart / orpheline / en_attente |
| `ecarts` | array | Détail des écarts si applicable |
| `pdf_url` | string | Lien vers le PDF (PennyLane ou Supabase Storage) |

### 7b.5 Intégration PennyLane

| Donnée | Direction | Fréquence |
|---|---|---|
| Factures fournisseurs | PennyLane → App | Polling toutes les heures |
| Statut de paiement | PennyLane → App | Polling toutes les heures |
| Fournisseurs | PennyLane ↔ App | Synchronisation bidirectionnelle |

**API PennyLane :** REST API documentée sur pennylane.readme.io
- Endpoint factures achat : récupération des factures fournisseurs avec détail des lignes
- Matching par fournisseur (tiers) entre PennyLane et PhoodApp
- Authentification via clé API ou OAuth

---

## 8. Module 6 : Reporting (V1 essentiel)

### 8.1 Tableau de bord principal (focus opérationnel)

Le dashboard est orienté **opérationnel** pour donner en un coup d'oeil les informations critiques du jour :

```
┌─────────────────────────────────────────────────────────────┐
│  DASHBOARD - Mardi 03/03/2026                    ☀️ 18°C    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ⚠️ ALERTES (3)                                             │
│  ├── Stock bas : Poulet émincé (2 kg < tampon 5 kg)         │
│  ├── Anomalie non traitée : BC20260301-002 (48h !)          │
│  └── Prix à valider : Carottes (+5%, Transgourmet)          │
│                                                             │
│  📦 COMMANDES DU JOUR                                       │
│  ├── BC20260303-001 - Transgourmet - envoyée ✅              │
│  └── BC20260303-002 - Promocash - brouillon 📝              │
│                                                             │
│  🚚 RÉCEPTIONS À FAIRE                                      │
│  ├── Transgourmet - livraison prévue aujourd'hui             │
│  └── TTfoods - livraison prévue demain                      │
│                                                             │
│  📊 STOCKS BAS (< tampon)                                   │
│  ├── Poulet émincé : 2 kg (tampon: 5 kg)                    │
│  ├── Sauce soja : 1.5 L (tampon: 3 L)                      │
│  └── [Voir tous les stocks →]                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 8.2 KPIs Coût matière (V1)

**Coût matière théorique vs réel — le KPI central de rentabilité :**

| KPI | Calcul | Description |
|---|---|---|
| **Coût matière théorique** | Σ (coût recette × quantités vendues) | Ce qu'on aurait dû consommer selon les recettes |
| **Coût matière réel** | Σ (achats réceptionnés - avoirs) | Ce qu'on a réellement acheté |
| **%CM théorique** | Coût matière théorique / CA HT × 100 | Ratio théorique |
| **%CM réel** | Coût matière réel / CA HT × 100 | Ratio réel |
| **Écart** | CM réel - CM théorique | Révèle pertes, sur-portionnement, vol |

**Affichage :**
- Période **personnalisable** (date début / date fin, avec présets semaine/mois/trimestre)
- Graphique d'évolution : CA HT et %CM réel sur la période (double axe Y)
- Variation vs période précédente (en % vert/rouge)
- Détail par produit si drill-down

### 8.3 Classement des produits (V1)

**Top 10 / Flop 10 :**
Toggle pour afficher les meilleurs ou les moins bons produits sur la période sélectionnée.

| Colonne | Description |
|---|---|
| Nom | Nom du produit (avec photo) |
| Marge HT | CA HT - Coût matière théorique |
| Nb. unités vendues | Volume de ventes |
| CA TTC | Chiffre d'affaires TTC |

Le classement peut être trié par chaque colonne.

### 8.4 Contrôle des associations produits caisse (V1)

**Écran dédié (Admin) :**
Liste de tous les produits Zelty avec leur statut d'association :
- **Associé** (vert) : Le produit Zelty est lié à une recette ou un ingrédient → stock décrémenté correctement
- **Non associé** (rouge) : Le produit Zelty n'est lié à rien → pas de décrémentation de stock

**Alerte automatique :**
Quand un nouveau produit apparaît sur Zelty (via webhook ou polling), si ce produit n'est associé à aucune recette/ingrédient, une alerte est affichée sur le dashboard : "Nouveau produit Zelty non associé : [nom du produit]"

L'admin peut alors créer la recette ou lier directement à un ingrédient fournisseur (produit sans recette).

### 8.5 Précision du modèle de prévision (V1)

**Score de précision S-1 :**
Chaque semaine, le système calcule l'écart entre la prévision de la semaine précédente et le réalisé :
```
precision_s1 = 1 - |CA_prevu - CA_realise| / CA_realise
```
Affiché en % sur l'écran des prévisions (ex: "Précision S-1 : 92%"). Permet de suivre la fiabilité du modèle dans le temps.

### 8.6 Vues disponibles

| Vue | Contenu |
|---|---|
| Dashboard | Alertes, commandes du jour, réceptions à faire, stocks bas, météo, KPIs CM |
| Commandes | Historique des commandes filtrables et consultables |
| Stocks | État des stocks par ingrédient avec niveaux d'alerte |
| Recettes | Liste des recettes avec coût matière et ratio |
| Fournisseurs | Fiche fournisseur avec historique commandes et conditions |
| **Analyse achats** | Historique des achats réellement reçus par produit (voir 8.7) |
| **Associations produits** | Contrôle des liaisons Zelty ↔ recettes/ingrédients |
| Factures | Rapprochement factures PennyLane vs BL + avoirs |

### 8.7 Analyse des achats (V1)

**Vue par produit :**
- Sélection de la période (semaine / mois / trimestre / personnalisée)
- Par produit fournisseur :
  - Quantités réellement reçues sur la période
  - Montant HT total sur la période
  - Prix moyen pondéré sur la période
  - Évolution dans le temps (graphique courbe/barres)
  - Fournisseur(s) concerné(s)

**Vue par fournisseur :**
- Montant total d'achats sur la période
- Répartition par catégorie de produit
- Nombre de commandes
- Nombre d'anomalies à réception / demandes d'avoir

**Filtres disponibles :**
- Par période (date début / date fin)
- Par fournisseur
- Par catégorie de produit
- Par ingrédient spécifique

**Données source :** Les quantités sont basées sur les réceptions validées (BL), pas sur les commandes (BC).

---

## 9. Gestion des utilisateurs et droits

### 9.1 Rôles

> **Philosophie V1 :** La team (Manager + Opérateur) ne fait que **commandes** et **contrôle à réception** + recherche allergènes au comptoir. Tout le reste est réservé à l'Admin. Les permissions pourront être étendues ultérieurement dans les paramètres.

| Fonctionnalité | Admin | Manager | Opérateur | Notes |
|---|---|---|---|---|
| **Mercuriale** : consulter | ✅ | ✅ | ✅ | Nécessaire pour les commandes |
| **Mercuriale** : modifier/créer | ✅ | ❌ | ❌ | |
| **Fournisseurs** : consulter | ✅ | ✅ | ✅ | Nécessaire pour les commandes |
| **Fournisseurs** : modifier/créer | ✅ | ❌ | ❌ | |
| **Commandes** : créer (brouillon) | ✅ | ✅ | ✅ | |
| **Commandes** : valider et envoyer | ✅ | ✅ | ❌ | |
| **Réception** : contrôle BL | ✅ | ✅ | ✅ | |
| **Réception** : valider le contrôle | ✅ | ✅ | ❌ | Incrémente les stocks |
| **Réception** : demande d'avoir | ✅ | ✅ | ❌ | |
| **Recherche allergènes** (5.4b) | ✅ | ✅ | ✅ | Usage au comptoir client |
| **Recettes** : consulter | ✅ | ✅ | ✅ | Consultation en cuisine |
| **Recettes** : modifier/créer | ✅ | ❌ | ❌ | |
| **Création rapide recette IA** (5.4e) | ✅ | ❌ | ❌ | |
| **Upload massif photos compositions** | ✅ | ❌ | ❌ | |
| **Analyse rentabilité / simulateur prix** (5.4f) | ✅ | ❌ | ❌ | |
| **Dashboard comparatif fournisseurs** (5.5b) | ✅ | ❌ | ❌ | |
| **Inventaire** : saisir | ✅ | ✅ | ✅ | Comptage physique |
| **Inventaire** : valider | ✅ | ❌ | ❌ | |
| **Stocks** : consulter | ✅ | ✅ | ✅ | Lecture seule pour la team |
| **Prévisions** : consulter | ✅ | ❌ | ❌ | |
| **Prévisions** : configurer (événements, coefficients) | ✅ | ❌ | ❌ | |
| **Contrôle associations produits** (8.4) | ✅ | ❌ | ❌ | |
| **Dépannage / PennyLane** | ✅ | ❌ | ❌ | |
| **Reporting** : consulter | ✅ | ❌ | ❌ | |
| **Notifications** : voir dans le dashboard | ✅ | ✅ | ✅ | Notifications pertinentes au rôle |
| **Notifications** : actions (valider prix, etc.) | ✅ | ❌ | ❌ | |
| **Validation prix mercuriale (détection IA)** | ✅ | ❌ | ❌ | |
| **Administration** : utilisateurs, config système | ✅ | ❌ | ❌ | |

> **Note :** Les notifications sont filtrées par rôle. La team ne voit que les notifications liées à leurs tâches (commandes à préparer, réceptions en attente). L'admin voit toutes les notifications (prix, compositions manquantes, produits non associés, factures dépannage, etc.).

### 9.2 Authentification (Supabase Auth)

- Login par email + mot de passe (Supabase Auth)
- Option : connexion via Google OAuth (Google Workspace Phood, domaine `@phood-restaurant.fr`)
- Session persistante (JWT géré automatiquement par `@supabase/supabase-js`)
- Déconnexion automatique après inactivité (durée configurable)
- Table `profiles` liée à `auth.users` via trigger `on_auth_user_created`
- Le rôle (`admin`/`manager`/`operator`) est stocké dans `profiles.role` et utilisé pour le Row Level Security via `get_my_role()` (voir section 2.5)

---

## 10. Contraintes UX / iPad

### 10.1 Principes fondamentaux

L'application sera utilisée principalement sur **iPad en cuisine et en zone de réception**. L'ergonomie tactile est PRIORITAIRE.

**Règles UX obligatoires :**

| Contrainte | Spécification |
|---|---|
| **Taille minimum des boutons** | 48x48px minimum (recommandé 56x56px) |
| **Espacement entre éléments cliquables** | 12px minimum entre deux zones tactiles |
| **Champs de saisie** | Hauteur minimum 48px, police 18px minimum |
| **Champs de date** | Sélecteur natif type calendrier (pas de saisie texte) |
| **Champs numériques** | Clavier numérique natif + boutons +/- larges |
| **Navigation** | Barre de navigation fixe en bas (thumb-friendly) |
| **Feedback tactile** | Retour visuel immédiat sur chaque interaction (highlight, animation) |
| **Scroll** | Scroll natif fluide, pas de scroll custom |
| **Gestes** | Swipe pour actions rapides (archiver, valider...) |

### 10.2 Responsive design

| Écran | Comportement |
|---|---|
| iPad (768px - 1024px) | Layout principal, optimisé pour le tactile |
| Desktop (> 1024px) | Layout étendu, utilisation de l'espace pour le reporting |
| Mobile (< 768px) | Consultation uniquement (non prioritaire V1) |

### 10.3 Mode plein écran

- L'application DOIT supporter le mode "Add to Home Screen" sur iPad
- Fonctionnement en plein écran (sans barre Safari)
- Icône d'application personnalisée (logo Phood)

---

## 11. Intégrations externes

### 11.1 Zelty (caisse enregistreuse)

| Donnée | Direction | Fréquence |
|---|---|---|
| Produits/carte | Zelty → App | Quotidien ou à la demande |
| Ventes (tickets) par canal | Zelty → App | Temps réel ou polling toutes les 15 min |
| Historique CA par canal | Zelty → App | Quotidien |
| Canaux de vente | Zelty → App | Sur place / Emporter / Livraison |

**Distinction par canal de vente :** Les ventes DOIVENT être ventilées par canal (sur place, emporter, livraison) car les volumes et comportements diffèrent significativement. Cette distinction est utilisée pour :
- Les prévisions de ventes (coefficients différents par canal)
- Le reporting (CA par canal)
- L'aide à la commande (consommation prévisionnelle par canal)

**Vente d'un produit sans association :**
Si un produit vendu sur Zelty n'est associé à aucune recette ni ingrédient dans PhoodApp :
- La vente est **comptée dans le CA** (pas de blocage de l'import)
- **Aucune décrémentation de stock** (impossible sans association)
- Une **alerte est générée** : "Produit [nom] non associé — vendu X fois sur la période" + email critique à l'admin
- L'admin peut alors créer l'association depuis l'écran Contrôle des associations

**Existant :** Un webhook Zelty est déjà actif (dossier `Projet/Zelty Webhook`). À réutiliser/adapter pour la nouvelle app.

#### 11.1b Récupération du CA historique (prévisions)

**Stratégie : Import initial + sync quotidien**

1. **Import initial one-shot** :
   - Récupérer 12-18 mois d'historique CA via l'endpoint `GET /orders` ou `GET /closures`
   - Agrégation par jour : CA TTC, nb tickets, nb couverts
   - Exécuté une seule fois au déploiement, via une Netlify Function dédiée
   - Pagination : `page` + `size` (max 100 par page)

2. **Sync quotidien automatique** (CRON) :
   - Chaque matin, une Netlify Scheduled Function récupère le Z de caisse (clôture) de la veille
   - Endpoint : `GET /closures/{date}` → CA définitif post-clôture
   - Stocke dans la table `ventes_historique` : date, CA TTC, nb tickets, nb couverts
   - Fallback : si la clôture n'est pas disponible, retry 1h plus tard (max 3 tentatives)

**Données stockées par jour :**

| Champ | Type | Description |
|---|---|---|
| `date` | date | Date du jour (PK) |
| `ca_ttc` | number | Chiffre d'affaires TTC du jour |
| `nb_tickets` | integer | Nombre de tickets encaissés |
| `nb_couverts` | integer | Nombre de couverts |
| `cloture_validee` | boolean | true si le Z de caisse est clôturé (donnée définitive) |
| `created_at` | timestamp | Date de création de l'enregistrement |

**API Zelty — Informations techniques :**
- Base URL : `https://api.zelty.fr/2.10/`
- Auth : `Authorization: Bearer {API_KEY}`
- Pagination : `?page=1&size=100` (max 100/page)
- Filtres date : `?date_from=YYYY-MM-DD&date_to=YYYY-MM-DD`
- Rate limits : non documentés — implémenter retry avec backoff exponentiel
- Endpoints clés : `/orders`, `/closures`, `/products`, `/payments`

**Note :** La clé API Zelty est déjà disponible (utilisée dans le webhook configurator existant). La documentation complète de l'API n'est pas publique — à explorer directement via les endpoints avec la clé existante.

### 11.2 Google Workspace (Gmail)

**API :** Gmail API v1 — `POST /gmail/v1/users/{userId}/messages/send`
**Auth :** Service Account + Domain-Wide Delegation (impersonne `team.begles@phood-restaurant.fr`)
**Scope :** `https://www.googleapis.com/auth/gmail.send`

| Usage | Détail |
|---|---|
| Envoi de commandes | Email + PDF brandé Phood en pièce jointe |
| Envoi de demandes d'avoir | Email + photos + tableau récapitulatif, CC configurable |
| Alertes critiques | Email immédiat (prix à valider, avoir sans réponse, etc.) |
| Adresse expéditeur | `team.begles@phood-restaurant.fr` |

**Format des emails :** Message MIME RFC 2822 encodé en base64url. Composition via `nodemailer/MailComposer` (Node.js) pour gérer facilement HTML + pièces jointes (PDF, images).

**Limites :** 2 000 emails/jour (limite Google Workspace), ~150 emails/min (quota API). Largement suffisant pour PhoodApp (~10-20 emails/jour max).

**Configuration (une seule fois) :**
1. Google Cloud Console : créer le projet, activer Gmail API, créer un Service Account, générer clé JSON
2. Google Admin Console (`admin.google.com`) : Sécurité > Contrôles d'API > Délégation au niveau du domaine → ajouter le Client ID du service account avec le scope `gmail.send`
3. Stocker la clé JSON en variable d'environnement Netlify (base64)

### 11.3 OpenAI (Vision)

**API :** `POST https://api.openai.com/v1/chat/completions`
**Modèle principal :** GPT-4.1-mini (vision + structured output, meilleur rapport qualité/prix)
**Modèle fallback :** GPT-4.1 standard (si précision insuffisante sur certains BL)
**SDK :** `openai` npm + `zod` pour les schémas JSON

| Usage | Détail | Coût estimé |
|---|---|---|
| Lecture de bons de livraison | Photo → JSON structuré (fournisseur, date, produits, quantités, prix) | ~0.13 ct€/BL |
| Détection allergènes | Photo packaging → liste 14 allergènes EU | ~0.13 ct€/photo |
| Détection écart prix | Extraction prix BL → comparaison avec mercuriale | inclus dans lecture BL |
| **Coût mensuel estimé** | **~30 BL + ~10 allergènes** | **~0.05 $/mois** |

**Spécifications techniques :**
- Images : JPEG/PNG, envoi en base64, `detail: "high"` pour OCR optimal
- Sortie JSON garantie : `response_format` avec JSON Schema + `strict: true`
- Température : `0.0` (déterminisme maximal pour OCR)
- Temps de réponse : 3-6 secondes (GPT-4.1-mini)
- Pré-traitement côté client : redimensionner à max 2048px avant envoi
- Champ `confidence` dans le schéma JSON pour gérer les images floues/illisibles
- Fallback : saisie manuelle si IA indisponible ou résultat insuffisant
- Pas besoin d'OCR dédié en complément (GPT-4.1-mini comprend la structure des documents)

**Stockage photos :** Supabase Storage (pour historique/audit des BL)

**Extraction IA depuis photo packaging / étiquette :**
1. L'admin prend en photo le packaging/étiquette d'un ingrédient fournisseur
2. GPT-4.1-mini extrait **en un seul appel** :
   - Les **14 allergènes réglementaires EU** → champ `allergenes`
   - La **liste complète des ingrédients** → champ `contient` (pour les produits achetés tout prêts type sauces, préparations)
3. Les allergènes sont pré-remplis sur l'ingrédient fournisseur → propagés à l'ingrédient restaurant
4. Le champ `contient` alimente la recherche allergènes étendue (voir 5.4b) pour les ingrédients sans sous-recette
5. Les fiches allergènes des recettes sont calculées automatiquement (union des allergènes de tous les ingrédients)
6. L'admin peut corriger/compléter manuellement

**14 allergènes réglementaires EU :**
Gluten, Crustacés, Oeufs, Poisson, Arachides, Soja, Lait, Fruits à coque, Céleri, Moutarde, Sésame, Sulfites, Lupin, Mollusques

### 11.4 API Météo — Open-Meteo

**API :** `https://api.open-meteo.com/v1/meteofrance` (modèles Météo-France AROME 1.5km + ARPEGE)
**Auth :** Aucune clé API requise (free tier)
**Coût :** Gratuit pour commencer, 29 $/mois si usage commercial avéré
**Coordonnées Bègles :** latitude=44.83, longitude=-0.57

| Usage | Endpoint | Fréquence |
|---|---|---|
| Prévisions J+7 | `GET /v1/meteofrance?...&daily=...` | 1 appel/jour (CRON) |
| Historique 18 mois | `GET /v1/archive?...&daily=...` | 1 appel one-shot |
| Rate limits (free) | 10 000 appels/jour | On en fait ~2-5/jour |

**Variables quotidiennes récupérées :**

| Variable | Usage pour prévision CA |
|---|---|
| `temperature_2m_max` / `_min` | Facteur secondaire (forte chaleur = mall climatisé attractif) |
| `precipitation_sum` (mm) | Corrélation **POSITIVE** avec CA (pluie = plus de clients CC) |
| `sunshine_duration` (secondes) | Corrélation **NÉGATIVE** avec CA (soleil = moins de clients CC) |
| `cloud_cover_mean` (%) | Facteur complémentaire à l'ensoleillement |
| `weather_code` (WMO) | Catégorisation : pluie (61-67), soleil (0-1), couvert (2-3) |

**Historique :** Archive API (ERA5) depuis 1940 à 10 km de résolution. Historical Forecast API depuis 2022 en haute précision. Largement suffisant pour les 12-18 mois de calibration avec le CA Zelty.

**Stockage :** Table Supabase `meteo_daily` (date, temp_min, temp_max, precipitation_mm, sunshine_s, cloud_cover_pct, weather_code). Jointure SQL avec `ventes_historique` sur la date pour calculer les coefficients de corrélation.

**Choix Open-Meteo vs alternatives :**
- OpenWeatherMap : pas de modèle haute résolution France, pas de durée d'ensoleillement native
- Météo-France direct : API complexe (WCS/WMS), rate limiting agressif, intégration difficile
- Open-Meteo intègre déjà les modèles AROME/ARPEGE de Météo-France via une API REST simple en JSON

### 11.5 PennyLane (comptabilité)

**API :** `https://app.pennylane.com/api/external/v2`
**Auth :** Token API d'entreprise (Bearer token, lecture seule, durée illimitée)
**Doc :** [pennylane.readme.io](https://pennylane.readme.io/)

| Donnée | Direction | Fréquence | Endpoint |
|---|---|---|---|
| Factures fournisseurs | PennyLane → App | CRON quotidien (1×/jour le matin) | `GET /changelogs/supplier_invoices` + `GET /supplier_invoices/{id}` |
| Lignes de facture | PennyLane → App | À la demande (par facture) | `GET /supplier_invoices/{id}/invoice_lines` |
| Catégories analytiques | PennyLane → App | Sync initiale + à la demande | `GET /categories` |
| Fournisseurs | PennyLane → App | Sync initiale | `GET /suppliers` |
| Plan comptable | PennyLane → App | Sync initiale | `GET /ledger_accounts` |

#### 11.5a Détection des achats dépannage (sans BC)

**Principe :** Identifier les factures PennyLane catégorisées en "matières premières" (catégorie analytique dédiée) qui n'ont pas de bon de commande (BC) correspondant dans PhoodApp.

**Flux :**
1. CRON quotidien → `GET /changelogs/supplier_invoices?start_date={dernier_check}` pour détecter les nouvelles factures
2. Pour chaque nouvelle facture : `GET /supplier_invoices/{id}/categories` → vérifier si catégorie analytique = "matières premières"
3. Si oui : chercher un BC correspondant dans PhoodApp (même fournisseur + date proche + montant cohérent)
4. Si aucun BC trouvé → flagguer comme "dépannage" + alerte dashboard + email critique

**⚠️ Pas de webhooks natifs PennyLane** — utilisation du système de changelog (polling). Rétention des changements : 4 semaines.

#### 11.5b Rapprochement factures / BL

**Principe :** Vérifier que chaque facture fournisseur correspond aux bons de livraison reçus dans PhoodApp (montants, quantités).

**Flux :**
1. Quand une nouvelle facture est détectée, le système cherche les réceptions correspondantes (même fournisseur, période proche)
2. Comparaison : montant facture TTC vs somme des BL réceptionnés
3. Si écart > seuil configurable (ex: 2%) → alerte "Écart facture/BL" avec détail
4. Statut rapprochement : **Rapprochée** (OK) / **Écart détecté** (à vérifier) / **Sans BL** (dépannage) / **En attente** (pas encore de facture)

#### 11.5c Coût matière réel (facturé)

**Principe :** Calculer le coût matière réel à partir des factures PennyLane, et le comparer au coût matière théorique (basé sur les recettes × ventes Zelty).

**Calcul :**
```
coût_matière_réel = Σ factures "matières premières" sur la période (montant HT)
coût_matière_théorique = Σ (nb_ventes_produit × coût_recette) pour chaque produit vendu

ratio_réel = coût_matière_réel / CA_HT_période
ratio_théorique = coût_matière_théorique / CA_HT_période

écart = ratio_réel - ratio_théorique
```

Affiché dans le dashboard Reporting (section 8.1) — la période est personnalisable (semaine, mois, trimestre).

**Limites techniques PennyLane :**
- Rate limit : 25 requêtes / 5 secondes
- Pagination : curseur, max 100 résultats/page
- Lignes de facture = appel séparé par facture (pas embarqué dans la réponse)
- Changelog : rétention 4 semaines uniquement

**Prérequis :** Générer un token API dans PennyLane (Gestion > Paramètres > Connectivité > Développeurs). Permission "Lecture seule", durée "Illimitée". Le token n'est affiché qu'une seule fois à la création → le stocker immédiatement dans les variables d'environnement Netlify.

### 11.6 Google Calendar (rappels de commande)

**API :** Google Calendar API v3
**Auth :** Service Account + Domain-Wide Delegation (même service account que Gmail)
**Scope :** `https://www.googleapis.com/auth/calendar` (à ajouter dans la délégation domaine avec le scope Gmail)

Aujourd'hui les rappels de commande sont gérés manuellement dans Google Calendar, sans lien avec le logiciel. PhoodApp automatise cette gestion.

| Donnée | Direction | Fréquence | Endpoint |
|---|---|---|---|
| Événements de commande | App → Google Calendar | À la création/modification d'un profil fournisseur | `POST /calendars/{id}/events` |
| Statut événement | App → Google Calendar | À chaque action sur une commande | `PUT /calendars/{id}/events/{eventId}` |
| Instances récurrentes | App → Google Calendar | Modification d'une occurrence | `GET /events/{id}/instances` + `PUT` |

**Principe :**
Le système crée des **événements récurrents** (format RRULE RFC 5545) dans un Google Calendar configurable, basés sur les profils fournisseurs (jours de commande + heure limite).

**Workflow semi-automatique :**
```
1. L'admin configure un profil fournisseur (jours commande, heure limite)
2. Le système PROPOSE les événements récurrents dans l'app
3. L'admin valide/ajuste (horaire, fréquence) avant création dans GC
4. Les événements sont créés dans le Google Calendar choisi
```

**Cycle de vie d'un événement commande :**

| Action | Effet sur l'événement GC |
|---|---|
| Événement créé | Titre : "Commande [Fournisseur] — avant [heure limite]" |
| Commande envoyée via PhoodApp | Instance mise à jour : "✅ Commandé — [Fournisseur] — BC{numero}" |
| Commande sautée (assez de stock) | Instance mise à jour : "⏭️ Sauté — [Fournisseur]" + log dans l'app |
| Commande reportée | Instance déplacée à la date choisie par l'utilisateur |

**Points importants :**
- Les événements **restent dans le calendrier** même après action (historique visible dans GC)
- Le calendrier cible est **configurable** par l'admin dans les paramètres (ex: calendrier dédié "Commandes Phood" ou calendrier existant)
- Les événements incluent un **lien vers la commande** dans PhoodApp (URL dans la description)
- Métadonnées custom via `extendedProperties.private` (ex: `{ orderStatus: 'ordered', orderId: 'BC20260310-001' }`)
- Si le profil fournisseur change (jours de commande modifiés), les événements futurs sont mis à jour automatiquement
- L'équipe peut s'abonner au calendrier pour recevoir les notifications GC sur leur téléphone
- Modification d'une instance = elle devient une "exception" au récurrent (l'instance a un ID différent du parent)

### 11.7 Google Business Profile (horaires d'ouverture)

**API :** My Business Business Information API v1
**Auth :** OAuth 2.0 obligatoire (PAS de service account — limitation Google)
**Scope :** `https://www.googleapis.com/auth/business.manage`

| Donnée | Direction | Fréquence | Endpoint |
|---|---|---|---|
| Horaires normaux (regularHours) | GBP → App | 1×/jour ou à la demande | `GET /locations/{id}?readMask=regularHours` |
| Fermetures exceptionnelles (specialHours) | GBP → App | 1×/jour ou à la demande | `GET /locations/{id}?readMask=specialHours` |

**Usage :** Connaître les jours d'ouverture/fermeture pour le module de prévision (CA = 0 les jours fermés, pas de consommation prévue).

**⚠️ Prérequis spécifiques (plus complexes que les autres APIs) :**
1. Profil Google Business vérifié et actif depuis **60+ jours**
2. Soumettre une **demande d'approbation** API via le formulaire Google ("Application for Basic API Access")
3. Configurer un flow **OAuth 2.0** initial (une seule fois) pour obtenir un refresh token
4. Stocker le refresh token dans les variables d'environnement Netlify
5. Le refresh token expire après 90 jours → prévoir un mécanisme de renouvellement

**Authentification OAuth (différente de Gmail/Calendar) :**
- Nécessite `client_id` + `client_secret` (OAuth, pas service account)
- Flow initial : générer URL d'auth → l'admin se connecte → callback avec code → échange contre tokens
- Refresh token stocké en variable d'env ou dans Supabase (table `config`)
- Access token renouvelé automatiquement (durée 1h)

**Données retournées :**
- `regularHours.periods[]` : jour de la semaine, heure ouverture, heure fermeture (peut avoir plusieurs périodes par jour)
- `specialHours.specialHourPeriods[]` : date, `isClosed` (boolean), horaires exceptionnels

**Fallback :** Si l'approbation GBP prend du temps ou si l'API pose problème, l'admin peut saisir manuellement les horaires dans une table Supabase `horaires_ouverture` via l'interface PhoodApp.

**Rate limits :** 300 QPM (queries per minute) après approbation. Largement suffisant (1-2 appels/jour).

### 11.8 Google Drive

| Usage | Détail |
|---|---|
| Stockage photos | BL, anomalies, produits (via Supabase Storage en priorité) |
| Backup données | Export quotidien des données Supabase |
| Structure dossiers | `/PhoodApp/photos/`, `/PhoodApp/backups/`, `/PhoodApp/pdf/` |

---

## 12. Sauvegarde et sécurité

### 12.1 Stratégie de backup

```
[Supabase PostgreSQL] ──(quotidien)──> [Google Drive /PhoodApp/backups/]
                                             |
                                             └── backup_{date}.sql
                                             └── backup_{date-1}.sql
                                             └── ... (rétention 30 jours)
```

- Backup automatique quotidien (via Supabase Edge Function + pg_cron)
- Export des données Supabase vers Google Drive
- Rétention : 30 derniers jours
- Backup manuel possible depuis l'interface Admin
- Restauration possible depuis l'interface Admin

### 12.2 Sécurité

- HTTPS obligatoire (Netlify le fournit par défaut)
- Clés API (Supabase, OpenAI, Google, Zelty) stockées dans les variables d'environnement Netlify (jamais dans le code)
- Les appels aux APIs externes passent par des Netlify Functions (serverless) pour ne jamais exposer les clés côté client
- Authentification gérée par Supabase Auth (JWT automatique)
- Row Level Security (RLS) sur Supabase pour sécuriser l'accès aux données par rôle
- Rate limiting sur les fonctions serverless critiques

---

## 13. Fonctionnalités V2+ (hors scope V1)

Ces fonctionnalités sont hors périmètre V1 mais l'architecture doit les permettre :

| Fonctionnalité | Priorité | Description |
|---|---|---|
| **Suivi des pertes** | V2 | Saisie des pertes par motif, analyse écart stock théorique/réel, alertes |
| **Suivi DLC** | V2 | Alertes DLC, FIFO, traçabilité lots |
| **Notifications push** | V2 | Alertes stock bas, commande en retard, anomalie réception |
| **Email résumé quotidien** | V2 | Récapitulatif quotidien des alertes et activité (les emails critiques immédiats sont en V1) |
| **Actions groupées commandes** | V2 | Sélection multiple + actions bulk (export PDF groupé, archivage) |
| **Export prévisions** | V2 | Export CSV/PDF des prévisions de CA |
| ~~**Comparaison N-1**~~ | ~~V2~~ → **V1** | Contexte N-1 sous chaque jour de prévision : météo N-1 (Open-Meteo Archive) + événements N-1 + CA réalisé N-1 (Zelty). Comparaison par jour de semaine, pas par date. Dashboard comparatif dédié reste en V2 |
| **Reporting avancé** | V2 | Évolution CA, prévision vs réel, analyse fournisseurs détaillée, marges |
| **Multi-sites** | V3 | Extension à d'autres restaurants du réseau |
| **Transferts de stock** | V3 | Transfert de marchandises entre sites |
| ~~**Gestion des factures**~~ | ~~V3~~ → **V1** | Rapprochement facture/BL via PennyLane API |
| **EDI fournisseurs** | V3 | Connexion directe avec les systèmes fournisseurs |
| **ML prévisions** | V2 | Modèle de machine learning pour améliorer les prévisions |

---

## 14. Modèle de données

### 14.1 Entités principales

```
┌──────────────────┐     ┌──────────────────────┐     ┌─────────────────┐
│   Fournisseur    │────<│ Ingrédient Fournisseur│>────│   Ingrédient    │
│                  │     │    (Mercuriale)       │     │   Restaurant    │
└──────────────────┘     └──────────────────────┘     └────────┬────────┘
                                                               │
                                                          (composition)
                                                               │
┌──────────────────┐     ┌──────────────────────┐     ┌────────┴────────┐
│  Bon de commande │────<│   Ligne commande     │     │     Recette     │
│                  │     │                      │     │ (Produit caisse)│
└───────┬──────────┘     └──────────────────────┘     └────────┬────────┘
        │                                                      │
   (réception)                                            (synchro)
        │                                                      │
┌───────┴──────────┐                                  ┌────────┴────────┐
│    Réception     │                                  │  Zelty Product  │
│  (contrôle BL)   │                                  │   (ventes)      │
└───────┬──────────┘                                  └─────────────────┘
        │
   (anomalie?)
        │
┌───────┴──────────┐
│ Demande d'avoir  │
└──────────────────┘

┌──────────────────┐     ┌──────────────────────┐
│   Inventaire     │────<│  Ligne inventaire    │
│   (session)      │     │  (comptage par       │
└──────────────────┘     │   ingrédient)        │
                         └──────────────────────┘

┌──────────────────┐     ┌──────────────────────┐
│   Événement      │     │    Utilisateur       │
│  (prévisions)    │     │   (rôle + auth)      │
└──────────────────┘     └──────────────────────┘
```

### 14.2 Tables Supabase (PostgreSQL)

| Table | Contenu | Volume estimé |
|---|---|---|
| `fournisseurs` | Profils fournisseurs | ~5-7 entrées |
| `mercuriale` | Catalogue produits fournisseurs | < 200 entrées |
| `historique_prix` | Historique des prix par produit fournisseur | Croissant (~500/an) |
| `ingredients_restaurant` | Ingrédients utilisés en cuisine | ~100-150 entrées |
| `recettes` | Recettes et sous-recettes avec composition | ~60-100 entrées |
| `recette_ingredients` | Table de liaison recette ↔ ingrédient (quantités) | ~500 entrées |
| `commandes` | Bons de commande | ~20-40/mois |
| `commande_lignes` | Lignes de commande | ~200-400/mois |
| `receptions` | Contrôles à réception | ~20-40/mois |
| `reception_lignes` | Lignes de réception avec statut | ~200-400/mois |
| `avoirs` | Demandes d'avoir | ~5-10/mois |
| `zones_stockage` | Zones physiques de stockage (froid+, froid-, sec, bar...) | ~4-5 entrées |
| `modeles_inventaires` | Templates d'inventaire (complet, par zone) | ~5-10 entrées |
| `inventaires` | Sessions d'inventaire | ~2-4/mois |
| `inventaire_lignes` | Comptages par ingrédient | ~200-600/mois |
| `achats_hors_commande` | Achats dépannage sans BC (récupérés via PennyLane) | ~5-15/mois |
| `evenements` | Événements pour prévisions (fériés, custom) | ~50-100/an |
| `stocks` | État des stocks en temps réel | ~100-150 entrées |
| `ventes_historique` | CA journalier Zelty (CA TTC, nb tickets, nb couverts, clôture validée) | 1 ligne/jour (~365-550 lignes) |
| `meteo_daily` | Données météo quotidiennes Open-Meteo (temp, pluie, ensoleillement, code WMO) | 1 ligne/jour (~365-550 lignes) |
| `factures_pennylane` | Factures fournisseurs importées de PennyLane (statut rapprochement) | ~20-40/mois |
| `horaires_ouverture` | Horaires d'ouverture (sync GBP ou saisie manuelle, fallback) | ~7-14 entrées |
| `utilisateurs` | Profils utilisateurs (lié à Supabase Auth) | < 10 entrées |
| `verrous` | Verrous d'édition sur les commandes | Volatile |
| `repartition_horaire` | Courbes de répartition CA par créneau horaire et jour de semaine (calibrées depuis Zelty) | ~84 entrées (7 jours × 12 créneaux) |
| `cron_logs` | Historique d'exécution des CRON jobs (timestamp, statut, durée, erreurs) | ~120/mois (4 jobs × 30 jours) |
| `profiles` | Profils utilisateurs liés à `auth.users` (rôle, préférences) | < 10 entrées |
| `config` | Paramètres système | 1 entrée |

**Avantages Supabase vs JSONBin :**
- Requêtes SQL (filtres, agrégations, jointures) sans limitation
- Auth intégrée avec Row Level Security
- Temps réel (verrouillage, sync multi-utilisateurs)
- 500 MB gratuit (largement suffisant pour ce volume)
- API REST + client JS généré automatiquement

---

## 15. Décisions prises

### Architecture
- [x] **Framework frontend** : Vue.js 3 (Composition API) - léger, PWA native, bonne DX
- [x] **Base de données** : Supabase (PostgreSQL) - auth intégrée, temps réel, 500MB gratuit
- [x] **Authentification** : Supabase Auth (email/password + option Google OAuth Workspace). Table `profiles` avec `get_my_role()` pour RLS
- [x] **Stockage fichiers** : Supabase Storage (photos, PDFs) + Google Drive (backups). 4 buckets privés avec RLS
- [x] **PDF** : jsPDF + jspdf-autotable (~526 KB bundle). Génération client-side, fonctionne hors-ligne. Design Phood brandé (logo, couleurs)
- [x] **CRON** : Supabase Edge Functions (Deno) déclenchées via pg_cron + pg_net. 4 jobs quotidiens (Zelty CA, PennyLane, météo, GBP). Architecture centralisée dans Supabase, pas de Netlify Scheduled Functions
- [x] **Realtime** : Supabase Presence channels pour verrouillage des commandes. Heartbeat 30s, timeout 15 min
- [x] **Supabase tier** : Free tier pour démarrer (500 MB DB, 1 GB storage, 200 realtime, 500K Edge Function invocations). Volume estimé < 50 MB/an, suffisant pour 2-3 ans
- [x] **Calendriers automatiques** : Jours fériés via calcul local (algorithme de Meeus/Jones/Butcher pour Pâques, ~40 lignes JS). Vacances scolaires via API `data.education.gouv.fr` (Zone A = Bordeaux). Soldes via calcul local + table d'override

### Fonctionnel
- [x] **Gestion des prix** : Historique complet des changements de prix par produit fournisseur, alertes si augmentation > seuil, comparaison fournisseurs possible
- [x] **Sous-recettes** : Oui, quelques sous-recettes (sauces, marinades) partagées entre plats
- [x] **Unités et conversions** : Conversions surtout utiles au niveau des recettes (pas pour les stocks). Le coefficient de conversion est défini par ingrédient fournisseur pour le lien commande → recette
- [x] **Multi-canal Zelty** : Oui, distinction obligatoire sur place / emporter / livraison dans prévisions et reporting
- [x] **Commandes brouillon** : Oui, brouillons persistants - une commande peut être commencée le matin et reprise l'après-midi
- [x] **Accès concurrent** : Verrouillage - le premier utilisateur verrouille la commande, le second voit "en cours de modification par X"
- [x] **Envoi email commande** : Prévisualisation obligatoire (aperçu email + PDF) avant envoi, confirmation manuelle

### UX et fonctionnel (analyse screenshots inpulse)
- [x] **Statuts commande** : Brouillon → Envoyée → Réceptionnée → Contrôlée → Validée / Avoir en cours → Clôturée
- [x] **Zones de stockage** : 4-5 zones (froid positif, froid négatif, sec, bar, autre) — inventaires organisés par zone
- [x] **Modèles d'inventaires** : Templates pré-configurés (complet + partiel par zone)
- [x] **Conditionnements** : Radio pour commande (1 seul), checkbox pour inventaire (plusieurs), champ maximum
- [x] **Champs mercuriale ajoutés** : dlc_ddm_jours, pertes_pct, prix_modifiable_reception (pas de code EAN13, le SKU fournisseur suffit)
- [x] **Sous-recettes imbriquées** : Jusqu'à 3 niveaux (sauce → marinade → préparation → plat)
- [x] **Stock sous-recettes** : Pas de stock propre — décrémentation toujours récursive jusqu'aux ingrédients de base, pas de saisie de production
- [x] **Vue "utilisé dans"** : V1 — chaque fiche affiche la liste des éléments parents qui l'utilisent
- [x] **Coût matière théorique vs réel** : V1 — KPI central du dashboard, période personnalisable
- [x] **Top 10 / Flop 10** : V1 — classement produits par marge, unités vendues, CA TTC
- [x] **Contrôle associations produits caisse** : V1 — écran de vérification + alerte auto nouveau produit Zelty non associé
- [x] **Précision S-1** : V1 — score de fiabilité du modèle de prévision
- [x] **Détail expandable mercuriale** : V1 — chevron ▼ avec détail du calcul de recommandation
- [x] **Toggle pré-remplir recommandations** : V1 — remplir toutes les quantités d'un clic
- [x] **Alerte stock ancien** : V1 — tooltip si données de stock > 30 jours
- [x] **Calendrier de livraison** : V1 — vue calendrier avec jours possibles (vert) / impossibles (rouge)
- [x] **Événements sportifs** : Impact faible en centre commercial, saisie manuelle suffisante, pas d'API sportive
- [x] **Actions groupées commandes** : V2
- [x] **Export prévisions** : V2
- [x] **Comparaison N-1** : ~~V2~~ → **V1** — Contexte N-1 expandable sous chaque jour de prévision (météo réelle N-1 via Open-Meteo Archive, événements N-1, CA réalisé N-1 via Zelty, écart prévision vs réalisé). Comparaison par jour de semaine équivalent. Dashboard comparatif dédié reste en V2. Import météo historique one-shot (même profondeur que CA Zelty, gratuit)
- [x] **Comparaison historique par jour de semaine** : Toujours comparer par jour de semaine équivalent (mardi vs mardi), jamais par date calendaire
- [x] **Événements mobiles** : Vacances, fériés mobiles (Pâques...) et soldes comparés à leur équivalent N-1 (même événement, pas même date)
- [x] **Calendriers automatiques** : Jours fériés + vacances scolaires zone Bordeaux + soldes pré-remplis chaque année
- [x] **Achats hors commande (dépannage)** : Factures PennyLane catégorie "matières premières" sans BC → détection auto, impact coût matière réel, ventilation par ingrédient optionnelle, fournisseurs ponctuels supportés
- [x] **Notifications V1** : Dashboard + email immédiat pour les alertes critiques (prix à valider, avoir sans réponse, nouveau produit Zelty non associé, facture dépannage détectée, **compositions ingrédients manquantes**). Destinataires **configurables par type d'alerte** (admin, manager, etc.). Clochette 🔔 avec badge compteur persistant pour les actions en attente (dont compositions manquantes → accès direct à l'upload massif de photos, voir 5.4b)
- [x] **Duplication commande** : Non nécessaire — le toggle pré-remplir avec recommandations suffit
- [x] **Vente Zelty sans association** : La vente est comptée dans le CA (pas de blocage), pas de décrémentation stock, alerte générée ("produit non associé vendu X fois")
- [x] **Inventaire** : Un seul utilisateur à la fois (pas de comptage multi-utilisateur simultané)
- [x] **Migration initiale** : Assistée par IA depuis inpulse.ai (Claude extension navigateur)
- [x] **Rappels commande Google Calendar** : Événements récurrents semi-automatiques (proposés par l'app, validés par l'admin), calendrier configurable, événements conservés pour historique (commandé/sauté/reporté), auto-update quand commande envoyée
- [x] **Récupération CA historique Zelty** : Import initial one-shot (12-18 mois) + sync quotidien automatique (CRON via Netlify Scheduled Function). Données stockées : CA TTC, nb tickets, nb couverts par jour. Pas de webhook pour le CA (sync quotidien post-clôture plus fiable). API Zelty v2.10, Bearer token, endpoints `/orders` et `/closures`.
- [x] **Intégration PennyLane V1** : Scope complet — détection dépannage (factures "matières premières" sans BC) + rapprochement factures/BL + coût matière réel vs théorique. API v2, token entreprise (lecture seule, illimité). CRON quotidien via changelog polling (pas de webhooks natifs). Catégorie analytique dédiée pour identifier les matières premières. Rate limit : 25 req/5s, pagination curseur max 100/page. Changelog : rétention 4 semaines.
- [x] **API Météo** : Open-Meteo (free tier pour commencer, 29$/mois si usage commercial avéré). Modèles Météo-France AROME 1.5km + ARPEGE intégrés. Variables : temp min/max, précipitations, ensoleillement, couverture nuageuse, code WMO. Historique via Archive API (ERA5 depuis 1940). 1 appel/jour suffit. Pas de clé API requise en free tier.
- [x] **Gmail API** : Service Account + Domain-Wide Delegation sur `team.begles@phood-restaurant.fr`. Scope `gmail.send`. Envoi MIME avec pièces jointes (PDF, images) via `nodemailer/MailComposer`. Limite 2 000 emails/jour.
- [x] **Google Calendar API** : Même service account que Gmail. Scope `calendar`. Événements récurrents RRULE RFC 5545, modification d'instances individuelles, métadonnées via `extendedProperties.private`.
- [x] **Google Business Profile API** : OAuth 2.0 obligatoire (pas de service account). Approbation API requise (formulaire Google, profil vérifié 60+ jours). Scope `business.manage`. Refresh token à stocker. Fallback : saisie manuelle des horaires dans Supabase si approbation retardée.
- [x] **OpenAI Vision** : GPT-4.1-mini (principal) + GPT-4.1 standard (fallback). Structured output JSON garanti (`strict: true`). ~0.05$/mois pour ~40 requêtes. Champ `confidence` pour gérer images floues. Pré-traitement client : redimensionner à max 2048px.
- [x] **Effet de rupture météo (acclimatation)** : V1 — Nouveau coefficient `coefficient_rupture_meteo` dans le modèle de prévision. Détecte les transitions météo brutales (ex : 4+ jours de pluie → beau temps soudain) et applique un coefficient d'amortissement sur J et J+1 (retour à la normale à J+2). Calibrage automatique à l'import initial en croisant CA Zelty historique et météo Open-Meteo Archive. Seuils configurables par l'admin (nb jours minimum, seuil pluie mm, seuil soleil heures, durée amortissement). Indicateur visuel ⚡ dans les prévisions quand rupture détectée. Si effet non significatif statistiquement, coefficient = 1.0.
- [x] **Effet températures extrêmes (non-linéarité)** : V1 — Le `coefficient_meteo` intègre un sous-coefficient `coefficient_temperature` non-linéaire (courbe en cloche). Le froid modéré = hausse CC (refuge), mais le froid extrême = atténuation (les gens restent chez eux). Le chaud = baisse CC, et la canicule = atténuation supplémentaire (apathie malgré la clim). Les seuils d'extrême sont basés sur l'**écart aux normales saisonnières** (pas les valeurs absolues), calibrés sur l'historique. Indicateurs visuels 🥶/🔥 dans les prévisions.
- [x] **~~Intégration Combo~~ (annulée)** : L'API Partner Combo n'est pas accessible avec le plan actuel (plan Time). La répartition horaire du CA est calculée nativement dans PhoodApp depuis les tickets Zelty horodatés (voir section 7.6). Le dashboard d'optimisation staffing est reporté en V2 si un plan Combo Pro est souscrit ultérieurement.

### Migration
- [x] **Historique ventes** : Import initial de 12-18 mois via API Zelty (`/orders` ou `/closures`) — CA TTC, nb tickets, nb couverts par jour. Puis sync quotidien automatique
- [x] **Historique commandes** : Repart de zéro
- [x] **Recettes** : Migration assistée par IA (Claude extension navigateur) depuis inpulse.ai
- [x] **Période de transition** : 1-2 mois en parallèle avec inpulse.ai

### Prérequis à configurer avant développement

**Google Cloud (un seul projet pour tout) :**
- [ ] Créer le projet Google Cloud (ex: `phood-app`)
- [ ] Activer les APIs : Gmail API, Google Calendar API, My Business Business Information API
- [ ] Créer un Service Account + générer clé JSON
- [ ] Google Admin Console (`admin.google.com`) : Sécurité > Contrôles d'API > Délégation domaine → ajouter Client ID avec scopes `gmail.send` + `calendar`
- [ ] Configurer OAuth 2.0 (client_id + client_secret) pour Business Profile API
- [ ] Soumettre la demande d'approbation GBP API (formulaire Google, "Application for Basic API Access")
- [ ] Effectuer le flow OAuth initial GBP pour obtenir le refresh token

**Autres APIs :**
- [ ] **Supabase** : Créer un projet, récupérer les clés API
- [ ] **OpenAI** : Clé API disponible (confirmé). Modèle : GPT-4.1-mini
- [ ] **Zelty** : Clé API disponible (webhook existant). Tester `/orders` et `/closures` pour valider l'accès historique CA
- [ ] **PennyLane** : Générer token API entreprise (Gestion > Paramètres > Connectivité > Développeurs). "Lecture seule", "Illimitée". ⚠️ Token affiché une seule fois. Plan Essential+ requis
- [ ] **Open-Meteo** : Aucune configuration requise (free tier sans clé API). Coordonnées Bègles : lat=44.83, lon=-0.57
- [x] ~~**Combo**~~ : Annulé — API Partner non accessible avec le plan actuel (plan Time, pas Pro). Répartition horaire du CA calculée nativement via Zelty

**Infra :**
- [ ] **Branding** : Récupérer logo SVG/PNG, codes couleurs, police Phood (confirmé disponible)
- [ ] **GitHub** : Créer le repository du projet
- [ ] **Netlify** : Créer un site, configurer le déploiement depuis GitHub, stocker toutes les clés API en variables d'environnement

### 15.1 Gestion des brouillons et verrouillage

**Brouillons persistants :**
- Une commande en statut `brouillon` est sauvegardée automatiquement dans Supabase
- Elle reste accessible depuis la liste des commandes avec un badge "Brouillon"
- L'opérateur peut la reprendre à tout moment depuis n'importe quel appareil
- Pas d'expiration automatique (nettoyage manuel par le manager si nécessaire)

**Verrouillage des commandes :**
- Quand un utilisateur ouvre une commande en édition, un verrou est posé (Supabase realtime)
- Les autres utilisateurs voient : "Commande en cours de modification par [nom]"
- Le verrou est relâché quand l'utilisateur quitte la page ou après 15 min d'inactivité
- Un manager/admin peut forcer le déverrouillage si nécessaire

### 15.2 Historique des prix fournisseurs

**Suivi complet des prix :**
- Chaque changement de prix dans la mercuriale est historisé avec date et prix précédent
- Alertes visuelles dans l'aide à la commande si le prix a changé depuis la dernière commande
- Affichage du % de variation (ex: "+3.3%")
- Vue récapitulative par fournisseur : évolution des prix sur les 3/6/12 derniers mois
- Comparaison possible entre fournisseurs pour un même ingrédient restaurant

### 15.3 Gestion des changements de prix

**Sources de mise à jour des prix :**

1. **Mise à jour manuelle anticipée** : L'admin peut saisir un prix futur avec date d'effet (ex: le fournisseur envoie sa nouvelle grille tarifaire). Le prix bascule automatiquement à la date d'effet.

2. **Détection automatique via IA (contrôle BL)** : Si l'IA détecte un prix différent sur le BL par rapport au prix en mercuriale :
   - L'opérateur est alerté immédiatement (anomalie prix)
   - Une notification est envoyée à l'Admin avec :
     - Le produit concerné
     - L'ancien prix vs le nouveau prix détecté
     - La preuve (photo du BL) en lien
   - L'Admin décide : **accepter** (mise à jour de la mercuriale) ou **rejeter** (conserver le prix actuel + demande d'avoir au fournisseur)

3. **Workflow de validation prix :**
```
[IA détecte écart prix sur BL]
     |
     v
[Anomalie "prix différent" créée sur la ligne de réception]
     |
     v
[Notification Admin : "Prix poulet émincé : 4.50€ → 4.75€ (Transgourmet)"]
     |
     ├── Admin ACCEPTE → Prix mercuriale mis à jour + historisé
     |
     └── Admin REJETTE → Prix conservé + demande d'avoir générée
```

---

## Annexes

### A. Wireframe conceptuel - Liste des commandes

```
┌─────────────────────────────────────────────────────────────────────┐
│  Commandes                        [Rechercher] [Filtrer] [+ Créer] │
├─────────────────────────────────────────────────────────────────────┤
│  □  Fournisseur     Date livr.   Date créa.   Statut    Total HT   │
├─────────────────────────────────────────────────────────────────────┤
│  □  Transgourmet    25/02/2026   23/02/2026   [Envoyée]  361.23€   │
│  □  DELIDRINKS      26/02/2026   20/02/2026   [Envoyée]  270.79€   │
│  □  Promocash       23/02/2026   20/02/2026   [Envoyée]  428.01€   │
│  □  Promocash       20/02/2026   19/02/2026   [Non conf]  511.32€  │
│  □  Transgourmet    20/02/2026   18/02/2026   [Validée]  305.22€   │
│  □  Promocash       18/02/2026   16/02/2026   [Validée]  554.77€   │
└─────────────────────────────────────────────────────────────────────┘
```

**Filtres disponibles :** par fournisseur, par statut, par période
**Tri :** par date de livraison (défaut, desc), fournisseur, date de création, total HT
**Actions ligne :** menu "..." (voir détail, dupliquer, modifier, exporter PDF)

### A2. Wireframe conceptuel - Calendrier de livraison (sélection date commande)

Lors de la création d'une commande, l'opérateur sélectionne la date de livraison via un calendrier visuel :

```
┌──────────────────────────────────────┐
│  Fournisseur: DELIDRINKS             │
│  [Livraison]  [Fin de période]       │
│                                      │
│       Mars 2026          Avril 2026  │
│  Lu Ma Me Je Ve Sa Di   Lu Ma Me Je  │
│                                      │
│   2  3  4  5  6  7  8               │
│       🟢    🟢       🟢              │
│   9 10 11 12 13 14 15               │
│       🟢    🟢       🟢              │
│  16 17 18 19 20 21 22               │
│       🔴    🟢       🟢              │
│                                      │
│  🟢 = livraison possible             │
│  🔴 = impossible / commande existante│
└──────────────────────────────────────┘
```

Les jours de livraison possibles sont calculés à partir du profil fournisseur (jours de livraison + délai commande → livraison).

### A3. Wireframe conceptuel - Écran de commande (iPad)

```
┌─────────────────────────────────────────────────────────────────┐
│  🏠  Commandes  │  Réception  │  Stocks  │  Recettes  │  ⚙️    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  📍 Bègles  │  🏢 Promocash Bordeaux  │  📅 mer 25 > ven 27    │
│                                                                 │
│  BC20260225-001                              [X] [💾] [📤]     │
│                                                                 │
│  [🔍 Rechercher]  Total HT: 0.00€  Franco: [250.00 🔴]         │
│                   Nb colis: 0       Poids: 0.00 kg              │
│                                                                 │
│               [○ Pré-remplir avec les recommandations]          │
│                                                                 │
│  ▼ Boissons                                          0.00 EUR   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 📷 Bière Heineken sans alcool...                         │   │
│  │    843616                                                │   │
│  │    Pack 6 cane...  │  4.88€  │  Stock: - │ ⚡9.09 u.     │   │
│  │    [  -  ] [  0  ] [  +  ]              0.00€  │  [▼]    │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │ 📷 Coca Cola Slim - 33CL                                │   │
│  │    345912                                                │   │
│  │    24 canettes...  │ 15.84€  │  Stock: - │ ⚡0.00 u.     │   │
│  │    [  -  ] [  0  ] [  +  ]              0.00€  │  [▼]    │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ▶ Boucherie                                         0.00 EUR   │
│  ▶ Crèmerie                                         0.00 EUR   │
│  ▶ Épicerie                                          0.00 EUR   │
│                                                                 │
│  [ 💾 Sauvegardé ]   [ 👁️ Prévisualiser ]  [ ✅ Valider ]     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Éléments UX clés de la mercuriale :**
- **En-tête fixe** : Restaurant + Fournisseur + Période + N° commande
- **Barre de stats** : Total HT, Franco (rouge si en dessous du minimum, vert si atteint), Nb colis, Poids total
- **Toggle recommandations** : Pré-remplir toutes les quantités avec les recommandations
- **Catégories en accordion** : Clic pour déplier/replier, total HT par catégorie à droite
- **Par produit** : Photo + Nom + Réf fournisseur (sous le nom) + Format + Prix u. HT + Stock hier + Recommandation (⚡) + Commande (+/-) + Total HT
- **Chevron ▼** : Détail expandable avec calcul de la recommandation
- **Tooltip stock** : Alerte si données > 30 jours
- **Franco** : Indicateur visuel rouge/vert avec montant restant si en dessous

### B. Références

- [Inpulse.ai](https://www.inpulse.ai) - Logiciel actuel (à remplacer)
- [Zelty API](https://blog.zelty.fr/solution-caisse-complete-integrations-api) - Documentation caisse
- [Supabase](https://supabase.com) - Base de données PostgreSQL + Auth + Storage
- [Netlify](https://www.netlify.com) - Hébergement + Serverless Functions
- [Vue.js 3](https://vuejs.org) - Framework frontend
- [OpenAI Vision](https://platform.openai.com) - IA lecture documents
- [Google Workspace API](https://developers.google.com/workspace) - Gmail, Drive
