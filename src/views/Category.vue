<script setup lang="ts">
import { watch, ref, onMounted } from "vue"
import { route, goTo } from "@/state/router"
import { store } from "@/state/store"
import type { Post } from "@/interface"
import { useSupabase } from "@/composables/supabase"

const supabase = useSupabase()

const pending = ref(false)
const fetchData = async () => {
  pending.value = true
  const { data } = await supabase
    .from<Post>("posts_with_metadata")
    .select("*, user:display_users!user_id(*)")
    .match({ category: route.params.category })
  if (data) {
    store.posts = data
  }
  pending.value = false
}

watch(
  () => route.params?.category,
  (n, o) => {
    if (n === o) return
    store.posts = []

    fetchData()
  },
  { immediate: true }
)

const upvote = async (post: Post) => {
  const isActive = post.active_for_user
  post.vote_count = post.active_for_user ? (post.vote_count ?? 0) - 1 : (post.vote_count ?? 0) + 1
  post.active_for_user = !post.active_for_user
  const { data, error } = await supabase.from("votes").upsert({
    user_id: supabase.auth.user()?.id ?? "",
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
        <ul v-else>
          <li class="p-6 border-b flex" v-for="post in store.posts">
            <button
              :class="[post.active_for_user ? 'text-orange-500 border-orange-500' : 'text-gray-400']"
              class="flex flex-col flex-shrink-0 items-center p-3 rounded-xl border w-16 h-max font-semibold"
              @click="upvote(post)"
            >
              <IonArrowUp></IonArrowUp>
              <span>{{ post.vote_count ?? 0 }}</span>
            </button>
            <button
              @click="goTo({ page: 'postview', params: post })"
              class="text-left ml-6 w-full flex items-center justify-between"
            >
              <div>
                <h3 class="font-medium">{{ post.title }}</h3>
                <h5 v-if="post.status">{{ post.status }}</h5>
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
