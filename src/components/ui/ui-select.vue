<template>
  <select class="ui-select h-8 rounded-md px-2" @change="e => $emit('update:modelValue', e.target.value)">
    <option v-for="item in items" :key="item[pk]" :value="item[pk]" :selected="modelValue === item[pk]">
      <slot name="item" :item="item">
        {{ item.text }}
      </slot>
    </option>
  </select>
</template>

<script>
export default {
  props: {
    modelValue: [String, Number],

    items: {
      type: Array,
      default() {
        return []
      },
    },

    pk: {
      type: String,
      default: 'id',
    },
  },

  emits: [
    'update:modelValue',
  ],
}
</script>

<style>
.ui-select {
  @apply border-1 border-gray-400;
  @apply dark:(text-black border-gray-500);
}
</style>
