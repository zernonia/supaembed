<script setup lang="ts">
import { useSupabase } from "@/composables/supabase"
import { useRouter } from "@/composables/router"
import { computed, onMounted, toRefs } from "vue"

import Roadmap from "./views/Roadmap.vue"
import Category from "./views/Category.vue"
import PostView from "./views/PostView.vue"
import { store } from "./state/store"

const routeMap = {
  roadmap: Roadmap,
  category: Category,
  postview: PostView,
}
const { route, goTo } = useRouter()
const supabase = useSupabase()

onMounted(async () => {
  const { data, error } = await supabase.rpc("is_admin").select("*")
  if (data) store.isAdmin = data as unknown as boolean
})

const currentView = computed(() => {
  //@ts-ignore
  let component = routeMap[route.page]
  if (component) return component
})
</script>

<template>
  <div class="max-w-screen-lg mx-auto">
    <span>isAdmin : {{ store.isAdmin }}</span>

    <component :is="currentView" />
  </div>
</template>
