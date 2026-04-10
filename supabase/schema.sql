create extension if not exists "uuid-ossp";

create table public.projects (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references auth.users(id) on delete cascade,
  name       text not null,
  color      text not null default '#6366f1',
  created_at timestamptz not null default now()
);

create table public.tasks (
  id         uuid primary key default uuid_generate_v4(),
  project_id uuid not null references public.projects(id) on delete cascade,
  user_id    uuid not null references auth.users(id) on delete cascade,
  name       text not null,
  created_at timestamptz not null default now()
);

create table public.time_entries (
  id         uuid primary key default uuid_generate_v4(),
  task_id    uuid not null references public.tasks(id) on delete cascade,
  user_id    uuid not null references auth.users(id) on delete cascade,
  started_at timestamptz not null default now(),
  ended_at   timestamptz,
  duration   integer,
  created_at timestamptz not null default now()
);

alter table public.projects     enable row level security;
alter table public.tasks        enable row level security;
alter table public.time_entries enable row level security;

create policy "projects: user owns"      on public.projects
  using (auth.uid() = user_id);

create policy "tasks: user owns"         on public.tasks
  using (auth.uid() = user_id);

create policy "time_entries: user owns"  on public.time_entries
  using (auth.uid() = user_id);
