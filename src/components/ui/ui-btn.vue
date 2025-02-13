<template>
  <button class="ui-btn" v-bind="$attrs">
    <span v-if="icon" class="m-icon">{{ icon }}</span>
    <slot></slot>
  </button>
</template>

<script>
export default {
  props: {
    icon: String,
  },
}
</script>

<style>
.ui-btn {
  @apply flex justify-center items-center rounded-md bg-gray-200 border-2 border-gray-300 select-none min-w-8 min-h-8 px-2 gap-2;
  @apply disabled:(border-dotted opacity-50 cursor-default);
  @apply dark:(bg-gray-700 border-gray-600);
}
</style>
