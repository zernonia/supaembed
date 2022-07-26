<script setup lang="ts">
import slugify from "slugify"
import { useSupabase } from "@/composables/supabase"
import { useRouter } from "@/composables/router"

const emits = defineEmits(["submitted"])

const { route, goTo } = useRouter()
const supabase = useSupabase()

const save = async (ev: any) => {
  const { data } = await supabase.from("posts").insert({
    ...ev,
    user_id: supabase.auth.user()?.id,
    slug: slugify(ev.title, { lower: true }),
    category: route.params.category,
  })
  emits("submitted")
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
    <h2 class="capitalize mb-2 font-medium">{{ route.params.category }}</h2>
    <p class="text-sm">
      {{ route.params.category === "bugs" ? "Find a bug? Report it here 🙌" : "Help us improve our product 💪" }}
    </p>
    <FormKit type="text" name="title" label="Title" placeholder="Short, descriptive title" validation="required" />
    <FormKit
      type="textarea"
      name="description"
      rows="6"
      placeholder="Tell us as much as possible about the bug / features"
      label="Description"
      validation="required"
    />
  </FormKit>
</template>

<style lang="postcss">
.formkit-form {
  @apply w-full bg-gray-50 text-gray-800 p-6 rounded-xl border;

  & label {
    @apply text-sm;
  }
}
.formkit-outer {
  @apply pt-2;
}
.formkit-messages {
  @apply text-xs text-red-500;
}

[data-type="submit"] .formkit-input,
[data-type="button"] .formkit-input {
  @apply relative inline-flex items-center bg-orange-500 px-4 py-2 w-auto text-white rounded-md focus:outline-orange-600 opacity-100 disabled:opacity-50 disabled:cursor-not-allowed transition;
}

[data-loading] [data-type="submit"] .formkit-input::before {
  -webkit-animation: rotate 0.5s linear infinite;
  animation: rotate 0.5s linear infinite;
  width: 1rem;
  border: 0.1428571429em solid #fff;
  border-right-color: transparent;
  margin-right: 0.75em;
}
[data-type="submit"] .formkit-input::before {
  box-sizing: border-box;
  content: "";
  width: 0;
  margin-right: 0;
  height: 1rem;
  border: 0 solid transparent;
  border-radius: 1rem;
  transition: width 0.25s, border 0.25s, margin-right 0.25s;
}
</style>
