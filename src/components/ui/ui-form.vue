<template>
  <form>
    <ui-frame>
      <slot />
    </ui-frame>
  </form>
</template>

<script>
import { computed } from 'vue'

export default {
  inject: {
    parentDisabled: {
      from: 'disabled',
      default: false,
    },
    parentReadonly: {
      from: 'readonly',
      default: false,
    },
  },

  provide() {
    return {
      disabled: computed(() => {
        return this.parentDisabled || this.disabled
      }),
      readonly: computed(() => {
        return this.parentReadonly || this.readonly
      }),
    }
  },

  props: {
    disabled: {
      type: Boolean,
      default: false,
    },
    readonly: {
      type: Boolean,
      default: false,
    },
  },
}
</script>
