<script setup lang="ts">
import { useSupabase } from "@/composables/supabase"
import { route, goTo } from "./state/router"
import { computed, onMounted, toRefs } from "vue"

import Roadmap from "./views/Roadmap.vue"
import Category from "./views/Category.vue"
import PostView from "./views/PostView.vue"

const routeMap = {
  roadmap: Roadmap,
  category: Category,
  postview: PostView,
}

const supabase = useSupabase()

onMounted(async () => {
  const { data } = await supabase.from("posts").select("*")
  console.log({ data })
})

const currentView = computed(() => {
  //@ts-ignore
  let component = routeMap[route.page]
  if (component) return component
})
</script>

<template>
  <div class="max-w-screen-lg mx-auto">
    <component :is="currentView" />
  </div>
</template>
