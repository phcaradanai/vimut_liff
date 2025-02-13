<template>
  <div class="ui-switch h-8 flex items-center" @click="toggleChecked">
    <div class="button flex justify-center items-center">
      <div class="m-icon w-4 h-4 text-[16px] justify-center items-center">
        {{ checked ? iconTrue : iconFalse }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    iconTrue: String,
    iconFalse: String,
    trueValue: String,
    falseValue: String,
    modelValue: [Boolean, String, Number],
  },

  emits: ['update:modelValue'],

  computed: {
    checked() {
      return this.modelValue === (this.trueValue ?? true)
    },
  },

  methods: {
    toggleChecked(e) {
      this.$emit('update:modelValue', this.checked ? (this.falseValue ?? false) : (this.trueValue ?? true))
    },
  },
}
</script>

<style>
.ui-switch {
  @apply w-12 border-2 border-gray-400 bg-gray-100 rounded-[16px] cursor-default;
  @apply dark:(border-gray-500 bg-gray-800 justify-end);
  > .button {
    @apply w-7 h-7 rounded-full bg-white text-black border-gray-300 border-2 flex;
    @apply dark:(bg-black text-white border-gray-600);
  }
}
</style>
