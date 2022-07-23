-- Create new schema in Supabase
create schema if not exists supaembed;
grant usage on schema supaembed to anon;
grant usage on schema supaembed to authenticated;


-- Create Posts table, grant access and set up RLS
create type status as enum ('under review', 'planned', 'in progress', 'live'); 
create table if not exists supaembed.posts (
  id uuid default uuid_generate_v4 () primary key,
  user_id uuid references auth.users on delete set null,
  title text not null,
  description text,
  slug text unique,
  created_at timestamptz default now(), 
  category text,
  status status default 'under review'
);
grant select, insert, update, delete on supaembed.posts to anon;
grant select, insert, update, delete on supaembed.posts to authenticated;
alter table supaembed.posts enable row level security;
create policy "Everyone can view posts." on supaembed.posts as permissive 
  for select using ( true );
create policy "Only authenticated user can insert post." on supaembed.posts as permissive 
  for insert to authenticated with check (true);
create policy "Only user that created the post can update." on supaembed.posts as permissive 
  for update using ( auth.uid() = user_id ) with check ( auth.uid() = user_id );
create policy "Only user that created the post can delete." on supaembed.posts as permissive 
  for delete using ( auth.uid() = user_id );
create policy "Admin can do anything to post." on supaembed.posts as permissive 
  for all using ( supaembed.is_admin() ); -- admin has the access to update the post's status


-- Create Votes table, grant access and set up RLS
create table if not exists supaembed.votes (
  post_id uuid references supaembed.posts on delete cascade,
  user_id uuid references auth.users on delete cascade,
  value int2,
  primary key(post_id, user_id)
);
grant select, insert, update, delete on supaembed.votes to anon;
grant select, insert, update, delete on supaembed.votes to authenticated;
alter table supaembed.votes enable row level security;
create policy "Everyone can view votes." on supaembed.votes as permissive 
  for select using ( true );
create policy "Only authenticated user can insert vote." on supaembed.votes as permissive 
  for insert to authenticated with check (true);
create policy "Only user that created the vote can update." on supaembed.votes as permissive 
  for update using ( auth.uid() = user_id ) with check ( auth.uid() = user_id );


-- Create Comments table, grant access and set up RLS
create table if not exists supaembed.comments (
  id uuid default uuid_generate_v4 () primary key,
  created_at timestamptz default now(), 
  post_id uuid references supaembed.posts on delete cascade,
  parent_id uuid references supaembed.comments on delete cascade,
  user_id uuid references auth.users on delete set null,
  comment text
);
grant select, insert, update, delete on supaembed.comments to anon;
grant select, insert, update, delete on supaembed.comments to authenticated;
alter table supaembed.comments enable row level security;
create policy "Everyone can view comments." on supaembed.comments as permissive 
  for select using ( true );
create policy "Only authenticated user can insert comment." on supaembed.comments as permissive 
  for insert to authenticated with check (true); 
create policy "Only user that created the comment can update." on supaembed.comments as permissive 
  for update using ( auth.uid() = user_id ) with check ( auth.uid() = user_id );
create policy "Only user that created the comment can delete." on supaembed.comments as permissive 
  for delete using ( auth.uid() = user_id );