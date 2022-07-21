<script setup lang="ts">
import { useSupabase } from "@/composables/supabase"
import type { Comment } from "@/interface"

const props = defineProps({
  post_id: String,
  parent_id: String,
})

const supabase = useSupabase()
const user = supabase.auth.user()

const save = async (ev: any) => {
  console.log(ev)
  const { data } = await supabase.from<Comment>("comments").insert({
    post_id: props.post_id,
    parent_id: props.parent_id,
    user_id: user?.id,
    comment: ev.comment,
  })
  console.log(data)
}
</script>

<template>
  <div class="flex">
    <Avatar class="ml-1 mr-7" :src="user?.user_metadata.avatar_url" :alt="user?.user_metadata.user_name"></Avatar>
    <FormKit
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
