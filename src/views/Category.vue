<script setup lang="ts">
import { route, goTo } from "@/state/router"
import Form from "@/components/Form.vue"
</script>
<template>
  <div>
    <nav>
      <button @click="goTo({ page: 'roadmap' })">Roadmap</button>
      <button @click="goTo({ page: 'category', params: { category: 'bugs' } })">Bugs</button>
    </nav>

    {{ route.params }}
    <h1>This is an about page</h1>

    <div>
      <div></div>
      <Form></Form>
    </div>
  </div>
</template>
