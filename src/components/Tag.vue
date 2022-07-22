<script setup lang="ts">
import { useSupabase } from "@/composables/supabase"
import { Status, type Post } from "@/interface"
import { store } from "@/state/store"
import { computed, ref, type PropType } from "vue"

const props = defineProps({
  post: { type: Object as PropType<Post>, required: true },
})
const computedClass = computed(() => {
  switch (props.post.status) {
    case Status["under review"]: {
      return "text-gray-500 bg-gray-100"
    }
    case Status["planned"]: {
      return "text-blue-500 bg-blue-100"
    }
    case Status["in progress"]: {
      return "text-orange-500 bg-orange-100"
    }
    case Status["live"]: {
      return "text-green-500 bg-green-100"
    }
  }
})

const supabase = useSupabase()
const isOpen = ref(false)
const openDropdown = () => {
  if (!store.isAdmin) return
  isOpen.value = !isOpen.value
}
const selectStatus = async (status: string) => {
  isOpen.value = false
  if (props.post.status !== status) {
    props.post.status = status
    const { error } = await supabase.from<Post>("posts").update({ status: status }).eq("id", props.post.id)
  }
}
</script>

<template>
  <div class="mt-1 relative w-max">
    <button @click="openDropdown" class="uppercase text-xs font-semibold px-2 py-1 rounded-md" :class="computedClass">
      {{ post.status }}
    </button>
    <ol v-if="isOpen" class="mt-1 absolute top-full left-0 border bg-white w-32 shadow-md rounded-lg py-2">
      <li v-for="status in Status" class="">
        <button
          @click="selectStatus(status)"
          class="py-2 px-2 w-full text-left uppercase text-gray-800 antialiased text-xs font-semibold bg-transparent hover:bg-orange-500 hover:text-white"
        >
          {{ status }}
        </button>
      </li>
    </ol>
  </div>
</template>
