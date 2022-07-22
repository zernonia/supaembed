<script setup lang="ts">
import { ref } from "vue"
import type { PropType } from "vue"
import type { Comment } from "@/interface"

defineProps({
  comment: { type: Object as PropType<Comment>, required: true },
})

const isReplying = ref(false)
</script>

<template>
  <div class="flex border-b py-4">
    <Avatar class="mx-1" :src="comment.user.avatar" :alt="comment.user.name"></Avatar>
    <div class="ml-6 mt-2 flex-grow">
      <h3 class="font-medium text-sm">{{ comment.user.name }}</h3>
      <p class="mt-2 line-clamp-2 text-sm text-gray-500">{{ comment.comment }}</p>

      <div class="text-gray-400 mt-4 text-xs flex">
        <p>{{ new Date(comment.created_at).toLocaleString() }}</p>
        <button @click="isReplying = !isReplying" class="flex items-center ml-8 hover:text-gray-800 transition">
          <IonReply class="mr-2 text-base"></IonReply> Reply
        </button>
      </div>

      <CommentInput
        v-bind="$attrs"
        class="mt-4"
        v-if="isReplying"
        :post_id="comment.post_id"
        :parent_id="comment.id"
        @submitted="isReplying = false"
      ></CommentInput>
      <Comment class="mt-4 border-none" v-for="child in comment.child" :comment="child"></Comment>
    </div>
  </div>
</template>
