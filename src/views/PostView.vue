<script setup lang="ts">
import type { Comment, Post } from "@/interface"
import { route, goTo } from "@/state/router"
import { store } from "@/state/store"
import { useSupabase } from "@/composables/supabase"
import { computed, onMounted, onUnmounted, watch } from "vue"

const supabase = useSupabase()

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
const post = computed(() => route.params as Post)

const recursiveComment = (comments: Comment[], parent_id: string | null) => {
  const arr: Comment[] = []
  comments.forEach((cmt) => {
    if (cmt.parent_id == parent_id) {
      const child = recursiveComment(comments, cmt.id)
      if (child) {
        cmt.child = []
        child.forEach((c_cmd) => {
          cmt.child?.push(c_cmd)
        })
      }
      arr.push(cmt)
    }
  })
  return arr
}

onUnmounted(() => {
  store.comments = []
})

onMounted(async () => {
  const { data } = await supabase
    .from<Comment>("comments")
    .select("*, user:display_users!user_id(*)")
    .eq("post_id", post.value.id)
  // .is("parent_id", null)
  if (data) {
    store.comments = recursiveComment(data, null)
    console.log(store.comments, recursiveComment(data, null))
  }
})
</script>

<template>
  <div>
    <nav>
      <button class="nav-button" @click="goTo({ page: 'category', params: route.params })">
        <IonBack class="mr-3"></IonBack><span class="mr-0.5">Back to board</span>
      </button>
    </nav>

    <div class="mt-8 w-full flex">
      <div class="flex-grow">
        <section class="p-6 border-b">
          <div class="flex">
            <button
              :class="[post.active_for_user ? 'text-orange-500 border-orange-500' : 'text-gray-400']"
              class="flex flex-col flex-shrink-0 items-center p-3 rounded-xl border w-16 h-max font-semibold"
              @click="upvote(post)"
            >
              <IonArrowUp></IonArrowUp>
              <span>{{ post.vote_count ?? 0 }}</span>
            </button>
            <div @click="goTo({ page: 'postview', params: post })" class="ml-6 w-full">
              <div class="mt-2">
                <h3 class="font-medium">{{ post.title }}</h3>
                <h5 v-if="post.status">{{ post.status }}</h5>
              </div>
            </div>
          </div>

          <div class="mt-6 flex">
            <Avatar class="mx-1" :src="post.user.avatar" :alt="post.user.name"></Avatar>
            <div class="ml-6 mt-2">
              <h3 class="font-medium text-sm">{{ post.user.name }}</h3>
              <p class="mt-2 line-clamp-2 text-sm text-gray-800">{{ post.description }}</p>
              <p class="text-gray-400 mt-4 text-xs">{{ new Date(post.created_at).toLocaleString() }}</p>
            </div>
          </div>
        </section>

        <!-- Comments -->
        <div class="p-6">
          <CommentInput :post_id="post.id"></CommentInput>

          <h5 class="mt-8 font-semibold text-gray-800">Activity</h5>

          <div class="mt-4">
            <Comment v-for="comment in store.comments" :comment="comment"></Comment>
          </div>
        </div>
      </div>
      <div class="ml-6 min-w-72">Voters</div>
    </div>
  </div>
</template>
