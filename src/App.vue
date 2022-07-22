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
    <a
      href="https://github.com/zernonia/supaembed"
      target="_blank"
      class="mb-6 flex items-center text-4xl font-semibold"
    >
      <h2 class="bg-orange-500 text-white px-4 py-2 rounded-xl w-min">Supaembed</h2>
      <h3 class="ml-4 text-gray-800">Feedback</h3>
    </a>
    <component :is="currentView" />
  </div>
</template>
