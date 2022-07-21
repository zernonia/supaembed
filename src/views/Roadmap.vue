<script setup lang="ts">
import { goTo } from "@/state/router"
</script>

<template>
  <div>
    <nav>
      <button @click="goTo({ page: 'category', params: { category: 'bugs' } })">Bugs</button>
    </nav>
    <main>Roadmap</main>
  </div>
</template>
