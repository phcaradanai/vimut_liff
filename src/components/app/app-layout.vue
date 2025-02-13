<template>
  <div class="app-layout" :class="{ 'show-nav': showNav }">
    <app-bar>
      <template #title>
        <slot name="title"></slot>
      </template>
      <template #actions>
        <slot name="actions"></slot>
      </template>
    </app-bar>
    <div class="content">
      <slot></slot>
    </div>
    <div v-if="showPanel" class="fixed top-10 bottom-0 right-0 left-0 bg-white shadow md:(top-12 left-[unset] w-160)">
      <slot name="panel"></slot>
    </div>
  </div>
</template>

<script>
import { mapState } from 'pinia'
import { useAppStore } from '@/store/app-store'

export default {
  props: {
    showPanel: Boolean,
  }, // props

  computed: {
    ...mapState(useAppStore, ['showNav']),
  }, // computed
}
</script>

<style>
.app-layout {
  @apply fixed top-0 bottom-0 left-0 right-0 flex flex-col;
  > .content {
    @apply px-2 py-1 flex-grow overflow-y-scroll flex;
    @apply md:(px-3 py-2);
  }
  &.show-nav {
    > .content {
      @apply md:(ml-80);
    }
  }
}
</style>
