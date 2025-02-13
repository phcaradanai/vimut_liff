<template>
  <teleport v-if="ready" to="#app-title">
    <slot></slot>
  </teleport>
</template>

<script>
export default {
  data() {
    return {
      ready: false,
    }
  },

  mounted() {
    this.ready = true
  },
}
</script>
