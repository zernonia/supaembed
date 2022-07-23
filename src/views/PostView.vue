<script setup lang="ts">
import type { Comment, Post, User, Vote } from "@/interface"
import { useRouter } from "@/composables/router"
import { useSupabase } from "@/composables/supabase"
import { computed, onMounted, onUnmounted, ref, watch } from "vue"

const { route, oldRoute, goTo } = useRouter()
const supabase = useSupabase()
const pending = ref(false)
const isEdit = ref(false)
const post = computed(() => route.params as Post)

const saveEdit = async () => {
  isEdit.value = false
  const { data, error } = await supabase
    .from<Post>("posts")
    .update({
      description: post.value.description,
    })
    .eq("id", post.value.id)
}
const deletePost = async () => {
  const { error } = await supabase.from<Post>("posts").delete().eq("id", post.value.id)
  goTo(oldRoute)
}

const comments = ref<Comment[]>([])
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

const fetchComment = async () => {
  pending.value = true
  const { data } = await supabase
    .from<Comment>("comments")
    .select("*, user:display_users!user_id(*)")
    .eq("post_id", post.value.id)
    .order("created_at", { ascending: true })
  if (data) {
    comments.value = recursiveComment(data, null)
  }
  pending.value = false
}

const voters = ref<Vote[]>([])
const fetchVoters = async () => {
  const { data } = await supabase.from<Vote>("votes").select("user:display_users!user_id(*)").match({
    post_id: post.value.id,
    value: 1,
  })
  if (data) voters.value = data
}

const upvote = async (post: Post) => {
  const isActive = post.active_for_user
  post.vote_count = post.active_for_user ? (post.vote_count ?? 0) - 1 : (post.vote_count ?? 0) + 1
  post.active_for_user = !post.active_for_user
  const { data, error } = await supabase.from("votes").upsert({
    user_id: supabase.auth.user()?.id,
    post_id: post.id,
    value: isActive ? 0 : 1,
  })
  if (data) fetchVoters()
}

onUnmounted(() => {
  comments.value = []
})

onMounted(async () => {
  fetchComment()
  fetchVoters()
})
</script>

<template>
  <div>
    <nav>
      <button class="nav-button" @click="goTo(oldRoute)">
        <IonBack class="mr-3"></IonBack><span class="mr-0.5">Back to board</span>
      </button>
    </nav>

    <div class="mt-8 w-full flex">
      <div class="flex-grow">
        <section class="p-6 border-b flex">
          <div class="flex flex-col">
            <button
              :class="[post.active_for_user ? 'text-orange-500 border-orange-500' : 'text-gray-400']"
              class="flex flex-col flex-shrink-0 items-center p-3 rounded-xl border w-16 h-max font-semibold"
              @click="upvote(post)"
            >
              <IonArrowUp></IonArrowUp>
              <span>{{ post.vote_count ?? 0 }}</span>
            </button>
            <Avatar class="mx-1 mt-6" :src="post.user.avatar" :alt="post.user.name"></Avatar>
          </div>

          <div v-if="!isEdit" class="ml-6 flex-grow flex flex-col group">
            <div class="mt-2">
              <h3 class="font-medium">{{ post.title }}</h3>
              <Tag :post="post"></Tag>
            </div>
            <div class="mt-6 w-full">
              <h3 class="font-medium text-sm">{{ post.user.name ?? "Anon" }}</h3>

              <div>
                <p class="mt-2 line-clamp-2 text-sm text-gray-800">{{ post.description }}</p>
                <div class="flex items-center mt-4">
                  <p class="text-gray-400 text-xs">{{ new Date(post.created_at).toLocaleString() }}</p>

                  <div v-if="post.user_id === supabase.auth.user()?.id" class="group-hover:flex items-center hidden">
                    <button
                      @click="isEdit = !isEdit"
                      class="text-gray-400 text-xs items-center ml-4 hover:text-gray-800 transition"
                    >
                      <IonEdit class="mr-2 text-base"></IonEdit>
                    </button>
                    <button
                      @click="deletePost"
                      class="text-gray-400 text-xs items-center ml-2 hover:text-gray-800 transition"
                    >
                      <IonTrash class="mr-2 text-base"></IonTrash>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <FormEdit class="ml-6 flex-grow-0 w-full text-sm" @cancel="isEdit = false" @save="saveEdit" v-else>
            <FormKit
              type="text"
              v-model="post.title"
              name="title"
              label="Title"
              placeholder="Short, descriptive title"
              validation="required"
            />
            <FormKit
              type="textarea"
              v-model="post.description"
              name="comment"
              rows="3"
              placeholder="Comment here"
              label="Description"
              validation="required"
            />
          </FormEdit>
        </section>

        <!-- Comments -->
        <div class="p-6">
          <CommentInput @submitted="fetchComment()" :post_id="post.id"></CommentInput>

          <h5 class="mt-8 font-semibold text-gray-800">Activity</h5>

          <div class="mt-4">
            <Loading v-if="pending && !comments.length"></Loading>
            <Comment
              @updated="fetchComment()"
              @submitted="fetchComment()"
              v-for="comment in comments"
              :comment="comment"
            ></Comment>
          </div>
        </div>
      </div>
      <div class="ml-6 min-w-72 bg-gray-50 text-gray-800 p-6 rounded-xl border h-min min-h-64">
        <h3 class="font-medium">Voters</h3>
        <div class="mt-6 flex flex-wrap">
          <Avatar class="mr-2 mb-2" v-for="{ user } in voters" :src="user.avatar" :alt="user.name"></Avatar>
        </div>
      </div>
    </div>
  </div>
</template>
