-- Create view to get user metadata
create or replace view supaembed.display_users as select 
  id, 
  coalesce(raw_user_meta_data ->> 'name', raw_user_meta_data ->> 'full_name', raw_user_meta_data ->> 'user_name') as name, 
  coalesce(raw_user_meta_data ->> 'avatar_url', raw_user_meta_data ->> 'avatar') as avatar 
from auth.users;
grant select, insert, update, delete on supaembed.display_users to anon;
grant select, insert, update, delete on supaembed.display_users to authenticated;

-- Create view to get post with metadata
create or replace view supaembed.posts_with_metadata
  as select *, 
    (select sum(value) from supaembed.votes b where b.post_id = a.id ) as vote_count,
    (select count(id) from supaembed.comments c where c.post_id = a.id ) as comment_count,
    (select bool_or((value > 0)) from supaembed.votes d where d.user_id = auth.uid() and d.post_id = a.id) as active_for_user
  from supaembed.posts a;
grant select, insert, update, delete on supaembed.posts_with_metadata to anon;
grant select, insert, update, delete on supaembed.posts_with_metadata to authenticated;

 