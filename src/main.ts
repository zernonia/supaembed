import { createApp, type InjectionKey } from "vue"
import { createClient, SupabaseClient } from "@supabase/supabase-js"
import App from "./App.vue"
import router from "./router"

import "./assets/main.css"
const app = createApp(App)

app.use(router)
app.provide(
  "supabase",
  createClient(import.meta.env.VITE_SUPABASE_URL, import.meta.env.VITE_SUPABASE_KEY, { schema: "supaembed" })
)

app.mount("#supaembed")
