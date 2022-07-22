<template>
  <div class="flex-shrink-0 w-14 h-14">
    <img v-if="$attrs.src" v-bind="$attrs" class="rounded-full object-cover" />
    <div
      v-else
      class="rounded-full bg-orange-500 text-gray-100 border-4 w-full h-full flex items-center justify-center"
    >
      <IonPerson class="text-2xl"></IonPerson>
    </div>
  </div>
</template>
