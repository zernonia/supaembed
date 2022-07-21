<script setup lang="ts">
import slugify from "slugify"
import { useSupabase } from "@/composables/supabase"
import { route } from "@/state/router"

const supabase = useSupabase()
const save = async (ev: any) => {
  const { data } = await supabase.from("posts").insert({
    ...ev,
    user_id: supabase.auth.user()?.id,
    slug: slugify(ev.title, { lower: true }),
    category: route.params.category,
  })
  console.log(ev, data)
}
</script>

<template>
  <FormKit
    type="form"
    :value="{
      title: '',
      description: '',
    }"
    submit-label="Submit"
    @submit="save"
  >
    <h2>Edit request</h2>
    <p>Edit your housing request below.</p>
    <FormKit type="text" name="title" label="Title" validation="required" />
    <FormKit type="textarea" name="description" label="Description" validation="required" />
  </FormKit>
</template>
