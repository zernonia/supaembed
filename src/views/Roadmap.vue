<script setup lang="ts">
import { useRouter } from "@/composables/router"
const { route, goTo } = useRouter()
</script>

<template>
  <div>
    <nav>
      <button @click="goTo({ page: 'category', params: { category: 'bugs' } })">Bugs</button>
    </nav>
    <main>Roadmap</main>
  </div>
</template>
