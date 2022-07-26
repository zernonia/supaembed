import type { Post, Comment } from "@/interface"
import { reactive } from "vue"

export const store = reactive({
  posts: [] as Post[],
  isAdmin: false,
})
