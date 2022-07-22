import { inject, onMounted } from "vue"
import { createClient, SupabaseClient } from "@supabase/supabase-js"

export const useSupabase = () => {
  const session = JSON.parse(localStorage.getItem("supabase.auth.token") ?? "{}")
  const access_token = session?.currentSession?.access_token

  const supabase = inject<SupabaseClient>("supabase") ?? createClient("", "")
  supabase.auth.setAuth(access_token)
  return supabase
}
