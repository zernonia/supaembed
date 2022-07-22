<script setup lang="ts">
import { useRouter } from "@/composables/router"
import { useSupabase } from "@/composables/supabase"
import { Status, type Post } from "@/interface"
import { computedStatusClass } from "@/utils"
import { computed, onMounted, ref } from "vue"
const { goTo } = useRouter()

const posts = ref<Post[]>([])
const supabase = useSupabase()

onMounted(async () => {
  const { data } = await supabase
    .from<Post>("posts_with_metadata")
    .select("*, user:display_users!user_id(*)")
    .order("created_at", { ascending: true })
  if (data) posts.value = data
})

const countFeatureRequest = computed(() => posts.value?.filter((i) => i.category === "feature requests").length)
const countBugs = computed(() => posts.value?.filter((i) => i.category === "bugs").length)

const postPlanned = computed(() => posts.value.filter((i) => i.status === Status["planned"]))
const postInProgress = computed(() => posts.value.filter((i) => i.status === Status["in progress"]))
const postLive = computed(() => posts.value.filter((i) => i.status === Status["live"]))
</script>

<template>
  <div>
    <nav class="grid grid-cols-2 gap-8">
      <button
        class="border text-sm flex items-center justify-between px-4 py-3 text-gray-400 hover:text-gray-800 bg-gray-50 hover:bg-gray-100 transition rounded-xl"
        @click="goTo({ page: 'category', params: { category: 'feature requests' } })"
      >
        Feature Requests
        <span class="min-w-7 px-2 py-0.5 bg-orange-500 text-white rounded-md">{{ countFeatureRequest }}</span>
      </button>
      <button
        class="border text-sm flex items-center justify-between px-4 py-3 text-gray-400 hover:text-gray-800 bg-gray-50 hover:bg-gray-100 transition rounded-xl"
        @click="goTo({ page: 'category', params: { category: 'bugs' } })"
      >
        Bugs <span class="min-w-7 px-2 py-0.5 bg-orange-500 text-white rounded-md">{{ countBugs }}</span>
      </button>
    </nav>

    <div class="grid grid-cols-3 gap-8 mt-8">
      <div class="py-6 px-4 bg-gray-50 rounded-xl border">
        <div
          class="w-max uppercase text-xs font-semibold px-3 py-1 rounded-md"
          :class="computedStatusClass(Status['planned'])"
        >
          {{ Status["planned"] }}
        </div>
        <ul>
          <button
            @click="goTo({ page: 'postview', params: post })"
            class="w-full text-left border flex justify-between items-center my-4 bg-white rounded-md"
            v-for="post in postPlanned"
          >
            <div class="border-l-4 border-blue-200 text-gray-800 p-4 flex flex-col justify-center">
              <h3 class="font-semibold antialiased leading-5">{{ post.title }}</h3>
              <p class="text-sm mt-1.5 font-light">{{ post.category }}</p>
            </div>
            <div
              class="flex flex-col flex-shrink-0 items-center text-orange-500 transition p-3 rounded-xl w-16 h-max font-semibold"
            >
              <IonArrowUp></IonArrowUp>
              <span>{{ post.vote_count ?? 0 }}</span>
            </div>
          </button>
        </ul>
      </div>

      <div class="py-6 px-4 bg-gray-50 rounded-xl border">
        <div
          class="w-max uppercase text-xs font-semibold px-3 py-1 rounded-md"
          :class="computedStatusClass(Status['in progress'])"
        >
          {{ Status["in progress"] }}
        </div>
        <ul>
          <button
            @click="goTo({ page: 'postview', params: post })"
            class="w-full text-left border flex justify-between items-center my-4 bg-white rounded-md"
            v-for="post in postInProgress"
          >
            <div class="border-l-4 border-orange-200 text-gray-800 p-4 flex flex-col justify-center">
              <h3 class="font-semibold antialiased leading-5">{{ post.title }}</h3>
              <p class="text-sm mt-1.5 font-light">{{ post.category }}</p>
            </div>
            <div
              class="flex flex-col flex-shrink-0 items-center text-orange-500 transition p-3 rounded-xl w-16 h-max font-semibold"
            >
              <IonArrowUp></IonArrowUp>
              <span>{{ post.vote_count ?? 0 }}</span>
            </div>
          </button>
        </ul>
      </div>

      <div class="py-6 px-4 bg-gray-50 rounded-xl border">
        <div
          class="w-max uppercase text-xs font-semibold px-3 py-1 rounded-md"
          :class="computedStatusClass(Status['live'])"
        >
          {{ Status["live"] }}
        </div>
        <ul>
          <button
            @click="goTo({ page: 'postview', params: post })"
            class="w-full text-left border flex justify-between items-center my-4 bg-white rounded-md"
            v-for="post in postLive"
          >
            <div class="border-l-4 border-green-200 text-gray-800 p-4 flex flex-col justify-center">
              <h3 class="font-semibold antialiased leading-5">{{ post.title }}</h3>
              <p class="text-sm mt-1.5 font-light">{{ post.category }}</p>
            </div>
            <div
              class="flex flex-col flex-shrink-0 items-center text-orange-500 transition p-3 rounded-xl w-16 h-max font-semibold"
            >
              <IonArrowUp></IonArrowUp>
              <span>{{ post.vote_count ?? 0 }}</span>
            </div>
          </button>
        </ul>
      </div>
    </div>
  </div>
</template>
