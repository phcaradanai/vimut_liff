<template>
  <router-view></router-view>
</template>

<script>
import { onMounted } from 'vue'

export default {
  setup() {
    console.log('public setup')

    onMounted(() => {
      console.log('default mounted')
    })
  },
}
</script>
