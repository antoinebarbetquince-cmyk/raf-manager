# ✅ Checklist Supabase — RAF Manager

## 1. Création du projet
- [ ] Créer un compte sur supabase.com
- [ ] Nouveau projet → noter **Project URL** et **anon key**
- [ ] Choisir la région Europe (Frankfurt recommandé)

## 2. Migrations SQL
- [ ] SQL Editor → coller et exécuter `001_init.sql`
- [ ] SQL Editor → coller et exécuter `002_realtime.sql`
- [ ] Vérifier dans **Table Editor** que les 6 tables sont créées
- [ ] Vérifier que les politiques RLS sont actives

## 3. Authentication
- [ ] Authentication → Providers → Email : activé
- [ ] Authentication → URL Configuration → Site URL : votre domaine
- [ ] (Optionnel) Ajouter Google / Microsoft SSO

## 4. Configuration de l'app
- [ ] Renseigner `supabaseUrl` dans `APP_CONFIG`
- [ ] Renseigner `supabaseKey` dans `APP_CONFIG`
- [ ] Passer `useSupabase: true`
- [ ] Décommenter le bloc `SUPABASE SYNC` dans `app.html`
- [ ] Ajouter l'import SDK dans le `<head>`

## 5. Déploiement
- [ ] Netlify / Vercel / GitHub Pages configuré
- [ ] Variables d'environnement définies dans le dashboard de déploiement
- [ ] URL de production ajoutée dans Supabase → Auth → URL Configuration

## 6. Tests
- [ ] Créer un compte utilisateur test
- [ ] Vérifier la création automatique du profil et des catégories
- [ ] Tester création / modification / suppression de tâche
- [ ] Vérifier que les données sont isolées par utilisateur (RLS)
- [ ] Tester le planning du jour et les slots
