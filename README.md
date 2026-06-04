# 📊 RAF Manager

> Application web de gestion de tâches pour Responsable Administratif et Financier.  
> Interface inspirée de Microsoft To Do — thème sombre — Agent IA intégré.

---

## ✨ Fonctionnalités

| Module | Description |
|---|---|
| **Tableau de bord** | KPI, graphiques par catégorie et priorité, alertes |
| **Ma journée** | Tâches du jour, focus quotidien |
| **Planning semaine** | Vue calendrier Lun–Ven, drag & drop entre journées |
| **Planning du jour** | Timeline horaire (7h–20h), placement à la souris, IA auto |
| **Kanban** | Colonnes À faire / En cours / Terminé — Ma journée uniquement |
| **Agent IA** | Chat + suggestions : priorités, délégation, organisation |
| **Récurrences** | Nouvelle tâche auto créée à la complétion (quotidien → trimestriel) |
| **Modèles** | Bibliothèque de tâches types RAF, sauvegarde depuis le détail |
| **Catégories** | Créer / modifier / supprimer avec emoji |
| **Notifications** | Alertes retards, tâches critiques, échéances J+1 |
| **Recherche** | Full-text sur titre, catégorie, notes |

---

## 🚀 Démarrage rapide (sans backend)

```bash
# Cloner le dépôt
git clone https://github.com/votre-org/raf-manager.git
cd raf-manager

# Ouvrir directement dans le navigateur
open src/app.html
# ou avec un serveur local
npx serve src/
```

L'application fonctionne **100% en local** via `localStorage` sans aucune dépendance.

---

## ⚙️ Configuration utilisateur

Dans `src/app.html`, modifiez le bloc `APP_CONFIG` :

```js
const APP_CONFIG = {
  userName: 'Sophie Mercier',        // Nom affiché dans la topbar
  userInitials: 'SM',                // Initiales avatar
  supabaseUrl: '',                   // URL du projet Supabase
  supabaseKey: '',                   // Clé anon publique Supabase
  useSupabase: false,                // true pour activer la sync cloud
};
```

> ⚠️ **Ne commitez jamais votre clé Supabase.** Utilisez un fichier `.env` ou la configuration Netlify/Vercel.

---

## 🗄️ Connexion Supabase

### 1. Créer le projet Supabase

1. Aller sur [supabase.com](https://supabase.com) → **New project**
2. Notez votre `Project URL` et votre `anon key`

### 2. Exécuter les migrations

Dans l'éditeur SQL Supabase (**SQL Editor → New query**) :

```sql
-- Exécutez dans l'ordre :
-- 1. supabase/migrations/001_init.sql
-- 2. supabase/migrations/002_realtime.sql
```

### 3. Configurer l'app

Dans `src/app.html`, renseignez `APP_CONFIG` :

```js
const APP_CONFIG = {
  userName: 'Votre Nom',
  userInitials: 'VN',
  supabaseUrl: 'https://xxxx.supabase.co',
  supabaseKey: 'eyJhbGciOiJI...',
  useSupabase: true,
};
```

### 4. Activer la sync dans le code

Dans `src/app.html`, décommentez le bloc **`// ── SUPABASE SYNC ──`** et appelez `syncTasks()` dans la section `INIT`.

### 5. Activer l'authentification (optionnel)

Dans Supabase → **Authentication → Providers** → Email activé.  
Ajoutez un écran de connexion ou utilisez le widget Supabase Auth UI.

---

## 🗂️ Structure du projet

```
raf-manager/
├── src/
│   └── app.html              # Application complète (single-file)
├── supabase/
│   └── migrations/
│       ├── 001_init.sql      # Tables, RLS, triggers, catégories par défaut
│       └── 002_realtime.sql  # Activation Realtime
├── docs/
│   └── schema.md             # Schéma de données détaillé
├── .gitignore
└── README.md
```

---

## 🗃️ Schéma de données

| Table | Rôle |
|---|---|
| `profiles` | Profil utilisateur (nom, initiales) |
| `categories` | Catégories personnalisées par utilisateur |
| `tasks` | Toutes les tâches (avec récurrence, priorité, statut…) |
| `schedule_slots` | Placement des tâches dans le planning du jour |
| `templates` | Modèles de tâches réutilisables |
| `notifications` | Historique des alertes |

Voir `docs/schema.md` pour le détail de chaque colonne.

---

## 🌐 Déploiement

### Netlify (recommandé — gratuit)
```bash
# Glissez le dossier src/ dans netlify.com/drop
# ou via CLI :
npm install -g netlify-cli
netlify deploy --dir=src --prod
```

### Vercel
```bash
npm install -g vercel
vercel --cwd src
```

### GitHub Pages
```bash
# Dans les Settings du repo → Pages → Source : /src
```

---

## ⌨️ Raccourcis clavier

| Touche | Action |
|---|---|
| `D` | Tableau de bord |
| `P` | Planning semaine |
| `J` | Planning du jour |
| `K` | Kanban |
| `A` | Agent IA |
| `N` | Nouvelle tâche |
| `Échap` | Fermer le panneau détail |

---

## 📄 Licence

MIT — Libre d'utilisation et de modification.
"# raf-manager" 
