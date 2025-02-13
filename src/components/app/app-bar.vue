<template>
  <div class="app-bar">
    <div class="icon">
      <ui-btn icon="menu" @click="toggleNav"></ui-btn>
    </div>
    <div class="title">
      <div class="logo">
        <img :src="`/images/xenex_${theme}.png`" class="h-6" />
      </div>
      <div class="text">
        <slot name="title"></slot>
      </div>
    </div>
    <div class="actions">
      <slot name="actions"></slot>
      <ui-btn icon="more_vert" disabled @click="actionClick"></ui-btn>
    </div>
  </div>
</template>

<script setup>
import { storeToRefs } from 'pinia'
import { useAppStore } from '@/store/app-store'

const appStore = useAppStore()

const actionClick = () => {
  console.log('action clicked')
}

const { theme } = storeToRefs(appStore)
const { toggleNav } = appStore
</script>

<style>
.app-bar {
  @apply h-10 bg-gray-100 flex shadow-sm shadow-gray-500/50 flex-shrink-0;
  @apply md:(h-12);
  @apply dark:(bg-dark-800 shadow-light-100/50);
  > .icon {
    @apply flex-shrink-0 px-2 py-1;
    @apply md:(px-3 py-2);
  }
  > .title {
    @apply flex-grow flex px-2 leading-10 flex items-center gap-x-3;
    @apply md:(px-3 leading-12 gap-x-6);
    > .logo {
      @apply hidden;
      @apply md:(block);
    }
  }
  > .actions {
    @apply flex-shrink-0 flex px-2 py-1 leading-10;
    @apply md:(px-3 py-2);
  }
}
</style>
