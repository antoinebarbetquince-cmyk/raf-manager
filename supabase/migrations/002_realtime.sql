-- ============================================================
--  RAF Manager — Activation Realtime Supabase
--  Migration : 002_realtime.sql
-- ============================================================

-- Active la réplication en temps réel pour les tables principales
alter publication supabase_realtime add table public.tasks;
alter publication supabase_realtime add table public.notifications;
alter publication supabase_realtime add table public.schedule_slots;
