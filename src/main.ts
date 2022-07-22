import { createApp } from "vue"
import { createClient } from "@supabase/supabase-js"
import { plugin, defaultConfig } from "@formkit/vue"
import Toast from "vue-toastification"
import App from "./App.vue"
import "virtual:windi.css"
import "./assets/main.css"
import "vue-toastification/dist/index.css"

const app = createApp(App)

const el = document.getElementById("supaembed")
app.use(plugin, defaultConfig)
app.use(Toast)
app.provide("supabase", createClient(el?.dataset.url ?? "", el?.dataset.anonKey ?? "", { schema: "supaembed" }))
el?.removeAttribute("data-url")
el?.removeAttribute("data-anon-key")

app.mount("#supaembed")
