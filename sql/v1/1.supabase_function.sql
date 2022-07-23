-- Function to check if the user is admin
create or replace function supaembed.is_admin ()
  returns boolean
  language plpgsql
  as
  $$
    begin
      return (select auth.uid() = any ('{
        cc734063-5b77-4161-a7f4-9c7646f91555,  -- replace with ids for your admin user
        96b05273-c784-4160-b37b-7457801ac24f,
      }'::uuid[]));
    end;
  $$
