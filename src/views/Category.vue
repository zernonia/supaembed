<script setup lang="ts">
import { watch, ref, onMounted, nextTick } from "vue"
import { useRouter } from "@/composables/router"
import { store } from "@/state/store"
import type { Post } from "@/interface"
import { useSupabase } from "@/composables/supabase"

const { route, goTo } = useRouter()
const supabase = useSupabase()

const pending = ref(false)
const fetchData = async () => {
  if (!route.params.category) return
  pending.value = true
  const { data } = await supabase
    .from<Post>("posts_with_metadata")
    .select("*, user:display_users!user_id(*)")
    .match({ category: route.params.category })
    .order("created_at", { ascending: true })
  if (data) {
    store.posts = data
  }
  pending.value = false
}

onMounted(() => {
  fetchData()
})

watch(
  () => route.params.category,
  (n, o) => {
    if (!n || !o) return
    if (n !== o) {
      console.log(n, o)
      store.posts = []
      fetchData()
    }
  },
  { immediate: true }
)

const upvote = async (post: Post) => {
  const isActive = post.active_for_user
  post.vote_count = post.active_for_user ? (post.vote_count ?? 0) - 1 : (post.vote_count ?? 0) + 1
  post.active_for_user = !post.active_for_user
  const { data, error } = await supabase.from("votes").upsert({
    user_id: supabase.auth.user()?.id,
    post_id: post.id,
    value: isActive ? 0 : 1,
  })
  console.log(data)
}
</script>
<template>
  <div>
    <nav class="flex space-x-2">
      <button class="nav-button" @click="goTo({ page: 'category', params: { category: 'bugs' } })">Bugs</button>
      <button class="nav-button" @click="goTo({ page: 'category', params: { category: 'feature requests' } })">
        Feature requests
      </button>
    </nav>

    <div class="w-full flex mt-4">
      <div class="flex-grow">
        <!-- <div>
          <input class="!w-64" type="search" placeholder="Search" />
        </div> -->
        <Loading v-if="pending && !store.posts.length"></Loading>
        <ul v-else :key="route.params?.category">
          <li class="border-b flex" v-for="post in store.posts">
            <div class="p-6">
              <button
                :class="[
                  post.active_for_user
                    ? 'text-orange-500 border-orange-500 hover:text-orange-600'
                    : 'text-gray-400 hover:text-gray-800',
                ]"
                class="flex flex-col flex-shrink-0 items-center transition p-3 rounded-xl border w-16 h-max font-semibold"
                @click="upvote(post)"
              >
                <IonArrowUp></IonArrowUp>
                <span>{{ post.vote_count ?? 0 }}</span>
              </button>
            </div>
            <button
              @click="goTo({ page: 'postview', params: post })"
              class="text-left my-3 rounded-xl p-3 w-full flex items-center justify-between transition bg-white hover:bg-gray-50"
            >
              <div>
                <h3 class="font-medium">{{ post.title }}</h3>
                <Tag :post="post"></Tag>
                <p class="mt-3 line-clamp-2 text-sm text-gray-500">{{ post.description }}</p>
              </div>

              <div v-if="post.comment_count" class="flex-shrink-0 text-gray-200 relative">
                <IonChat class="w-8 h-8"></IonChat>
                <span class="absolute -top-1 -right-1 bg-orange-500 text-white text-xs px-1.5 py-0.5 rounded">{{
                  post.comment_count
                }}</span>
              </div>
            </button>
          </li>
        </ul>
      </div>
      <div class="ml-6 min-w-72">
        <Form @submitted="fetchData"></Form>
      </div>
    </div>
  </div>
</template>
