import { createApp } from "vue"
import { createClient } from "@supabase/supabase-js"
import { plugin, defaultConfig } from "@formkit/vue"
import App from "./App.vue"
import "virtual:windi.css"
import "@formkit/themes/genesis"

import "./assets/main.css"
const app = createApp(App)

const el = document.getElementById("supaembed")
app.use(plugin, defaultConfig)
app.provide("supabase", createClient(el?.dataset.url ?? "", el?.dataset.anonKey ?? "", { schema: "supaembed" }))
el?.removeAttribute("data-url")
el?.removeAttribute("data-anon-key")

app.mount("#supaembed")
