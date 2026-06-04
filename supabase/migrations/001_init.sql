-- ============================================================
--  RAF Manager — Schéma Supabase
--  Migration : 001_init.sql
--  Créez ces tables dans l'éditeur SQL Supabase
-- ============================================================

-- ── EXTENSION uuid ──
create extension if not exists "uuid-ossp";

-- ============================================================
-- TABLE : profiles (utilisateurs)
-- ============================================================
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text not null default 'Responsable RAF',
  initials    text not null default 'RAF',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- ============================================================
-- TABLE : categories
-- ============================================================
create table if not exists public.categories (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  name       text not null,
  icon       text not null default '📁',
  position   integer not null default 0,
  created_at timestamptz not null default now()
);

-- Catégories par défaut (insérées via trigger ou seed)
-- cf. fichier supabase/seed.sql

-- ============================================================
-- TABLE : tasks
-- ============================================================
create table if not exists public.tasks (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null references public.profiles(id) on delete cascade,
  title       text not null,
  description text,
  due_date    date,
  time_est    numeric(4,1) default 1,       -- heures estimées
  category    text not null default 'Divers',
  priority    text not null default 'moyenne'
              check (priority in ('critique','haute','moyenne','faible')),
  status      text not null default 'todo'
              check (status in ('todo','inprogress','done')),
  responsible text,
  comments    text,
  starred     boolean not null default false,
  myjour      boolean not null default false, -- "Ma journée"
  recurrence  text default ''
              check (recurrence in ('','daily','weekly','monthly','quarterly')),
  parent_id   uuid references public.tasks(id),  -- tâche source si récurrente
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- ============================================================
-- TABLE : schedule_slots (Planning du jour)
-- ============================================================
create table if not exists public.schedule_slots (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null references public.profiles(id) on delete cascade,
  task_id     uuid not null references public.tasks(id) on delete cascade,
  slot_date   date not null default current_date,
  slot_hour   smallint not null check (slot_hour between 0 and 23),
  created_at  timestamptz not null default now(),
  unique (user_id, task_id, slot_date)
);

-- ============================================================
-- TABLE : templates (Modèles de tâches)
-- ============================================================
create table if not exists public.templates (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  title      text not null,
  category   text not null default 'Divers',
  priority   text not null default 'moyenne',
  time_est   numeric(4,1) default 1,
  recurrence text default '',
  comments   text,
  created_at timestamptz not null default now()
);

-- ============================================================
-- TABLE : notifications
-- ============================================================
create table if not exists public.notifications (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  icon       text,
  title      text not null,
  sub        text,
  type       text default 'info' check (type in ('info','warning','danger')),
  read       boolean not null default false,
  created_at timestamptz not null default now()
);

-- ============================================================
-- INDEXES
-- ============================================================
create index if not exists idx_tasks_user_id     on public.tasks(user_id);
create index if not exists idx_tasks_due_date    on public.tasks(due_date);
create index if not exists idx_tasks_status      on public.tasks(status);
create index if not exists idx_tasks_myjour      on public.tasks(myjour) where myjour = true;
create index if not exists idx_slots_user_date   on public.schedule_slots(user_id, slot_date);
create index if not exists idx_notifs_user_read  on public.notifications(user_id, read);

-- ============================================================
-- TRIGGERS : updated_at automatique
-- ============================================================
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger tasks_updated_at
  before update on public.tasks
  for each row execute function public.set_updated_at();

create trigger profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================
alter table public.profiles       enable row level security;
alter table public.categories     enable row level security;
alter table public.tasks          enable row level security;
alter table public.schedule_slots enable row level security;
alter table public.templates      enable row level security;
alter table public.notifications  enable row level security;

-- Profiles
create policy "profiles: own data"
  on public.profiles for all
  using (auth.uid() = id);

-- Categories
create policy "categories: own data"
  on public.categories for all
  using (auth.uid() = user_id);

-- Tasks
create policy "tasks: own data"
  on public.tasks for all
  using (auth.uid() = user_id);

-- Schedule slots
create policy "slots: own data"
  on public.schedule_slots for all
  using (auth.uid() = user_id);

-- Templates
create policy "templates: own data"
  on public.templates for all
  using (auth.uid() = user_id);

-- Notifications
create policy "notifications: own data"
  on public.notifications for all
  using (auth.uid() = user_id);

-- ============================================================
-- FONCTION : créer le profil automatiquement à l'inscription
-- ============================================================
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, full_name, initials)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', 'Responsable RAF'),
    coalesce(new.raw_user_meta_data->>'initials', 'RAF')
  );
  -- Catégories par défaut
  insert into public.categories (user_id, name, icon, position)
  values
    (new.id, 'Comptabilité',       '🟢', 1),
    (new.id, 'Trésorerie',         '🟠', 2),
    (new.id, 'Reporting',          '🔵', 3),
    (new.id, 'Fiscalité',          '🟣', 4),
    (new.id, 'Contrôle de gestion','📊', 5),
    (new.id, 'RH',                 '👥', 6),
    (new.id, 'Juridique',          '⚖️', 7),
    (new.id, 'Direction',          '🔴', 8),
    (new.id, 'Projets',            '🚀', 9),
    (new.id, 'Divers',             '📁', 10);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
