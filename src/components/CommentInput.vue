<script setup lang="ts">
import { reset } from "@formkit/core"
import { useSupabase } from "@/composables/supabase"
import type { Comment } from "@/interface"
import { ref } from "vue"

const props = defineProps({
  post_id: String,
  parent_id: String,
})

const emits = defineEmits(["submitted"])

const supabase = useSupabase()
const user = supabase.auth.user()

const save = async (ev: any) => {
  const { data } = await supabase.from<Comment>("comments").insert({
    post_id: props.post_id,
    parent_id: props.parent_id,
    user_id: user?.id,
    comment: ev.comment,
  })
  console.log(data)
  reset(`formkit-${props.post_id}-${props.parent_id}`)
  emits("submitted")
}
</script>

<template>
  <div class="flex">
    <Avatar class="ml-1 mr-7" :src="user?.user_metadata.avatar_url" :alt="user?.user_metadata.user_name"></Avatar>
    <FormKit
      :id="`formkit-${post_id}-${parent_id}`"
      type="form"
      :value="{
        comment: '',
      }"
      submit-label="Comment"
      @submit="save"
    >
      <FormKit type="textarea" name="comment" rows="2" placeholder="Comment here" validation="required" />
    </FormKit>
  </div>
</template>
