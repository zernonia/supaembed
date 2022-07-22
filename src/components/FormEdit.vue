<script setup lang="ts">
const emits = defineEmits(["save", "cancel"])
</script>

<template>
  <div>
    <slot></slot>

    <div class="flex space-x-2">
      <FormKit type="submit" @click="emits('save')">Save</FormKit>
      <FormKit input-class="!bg-gray-50 !hover:bg-gray-100 !text-orange-500" type="button" @click="emits('cancel')"
        >Cancel</FormKit
      >
    </div>
  </div>
</template>
