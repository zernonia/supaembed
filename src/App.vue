<script setup lang="ts">
import { useSupabase } from "@/composables/supabase"
import { route, goTo } from "./state/router"
import { computed, onMounted, toRefs } from "vue"

import Roadmap from "./views/Roadmap.vue"
import Category from "./views/Category.vue"

const routeMap = {
  roadmap: Roadmap,
  category: Category,
}

const supabase = useSupabase()

onMounted(async () => {
  const { data } = await supabase.from("posts").select("*")
  console.log({ data })
})

const upvote = async (value: number) => {
  const { data, error } = await supabase.from("votes").upsert({
    user_id: supabase.auth.user()?.id ?? "",
    post_id: "822dd28b-8cc5-4cdc-adf3-13f02f2bb009",
    value,
  })
}

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
