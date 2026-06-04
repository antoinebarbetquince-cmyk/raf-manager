# 📐 Schéma de données — RAF Manager

## Table `tasks`

| Colonne | Type | Description |
|---|---|---|
| `id` | uuid | Identifiant unique |
| `user_id` | uuid | Référence `profiles.id` |
| `title` | text | Titre de la tâche |
| `description` | text | Description longue |
| `due_date` | date | Date d'échéance |
| `time_est` | numeric | Temps estimé en heures |
| `category` | text | Nom de la catégorie |
| `priority` | text | `critique` \| `haute` \| `moyenne` \| `faible` |
| `status` | text | `todo` \| `inprogress` \| `done` |
| `responsible` | text | Personne responsable |
| `comments` | text | Notes libres |
| `starred` | boolean | Marqué "Important" |
| `myjour` | boolean | Dans "Ma journée" |
| `recurrence` | text | `daily` \| `weekly` \| `monthly` \| `quarterly` \| `''` |
| `parent_id` | uuid | Tâche source (si générée par récurrence) |
| `created_at` | timestamptz | Date de création |
| `updated_at` | timestamptz | Dernière modification (auto) |

## Table `schedule_slots`

| Colonne | Type | Description |
|---|---|---|
| `id` | uuid | Identifiant unique |
| `user_id` | uuid | Référence `profiles.id` |
| `task_id` | uuid | Référence `tasks.id` |
| `slot_date` | date | Jour du planning |
| `slot_hour` | smallint | Heure (7–20) |

## Table `categories`

| Colonne | Type | Description |
|---|---|---|
| `id` | uuid | Identifiant unique |
| `user_id` | uuid | Référence `profiles.id` |
| `name` | text | Nom de la catégorie |
| `icon` | text | Emoji |
| `position` | integer | Ordre d'affichage |

## Table `templates`

| Colonne | Type | Description |
|---|---|---|
| `id` | uuid | Identifiant unique |
| `user_id` | uuid | Référence `profiles.id` |
| `title` | text | Nom du modèle |
| `category` | text | Catégorie par défaut |
| `priority` | text | Priorité par défaut |
| `time_est` | numeric | Temps estimé |
| `recurrence` | text | Récurrence par défaut |
| `comments` | text | Notes par défaut |

## Table `notifications`

| Colonne | Type | Description |
|---|---|---|
| `id` | uuid | Identifiant unique |
| `user_id` | uuid | Référence `profiles.id` |
| `icon` | text | Emoji icône |
| `title` | text | Titre de l'alerte |
| `sub` | text | Sous-titre |
| `type` | text | `info` \| `warning` \| `danger` |
| `read` | boolean | Lue ou non |
| `created_at` | timestamptz | Date de création |
