<template>
  <router-view> </router-view>

  <div
    v-if="toast.show"
    class="fixed bottom-4 left-0 right-0 flex justify-center pointer-events-none"
  >
    <div
      class="bg-red-100 shadow-lg px-3 py-2 text-sm rounded-md pointer-events-auto min-w-80 max-w-160 flex gap-x-3"
    >
      <div id="toast-message" class="flex-grow text-sm leading-8">
        {{ toast.message }}
      </div>
      <div class="flex flex-shrink-0 gap-2">
        <ui-btn
          v-for="act in toast.actions"
          :key="act.id"
          @click="toastActionClick(act)"
        >
          {{ act.text }}
        </ui-btn>
      </div>
    </div>
  </div>
</template>

<script>
import { useAppStore } from '@/store/app-store'
import { useUiStore } from '@/store/ui-store'
import { mapState } from 'pinia'

export default {
  setup() {
    const appStore = useAppStore()
    const uiStore = useUiStore()
    const html = document.querySelector('html')
    html.classList.add(appStore.theme)

    return {
      appStore,
      uiStore,
    }
  },

  computed: {
    ...mapState(useUiStore, ['toast']),
  },

  watch: {
    'appStore.theme'(newValue, oldValue) {
      console.log('theme', newValue, oldValue)
      const html = document.querySelector('html')
      html.classList.remove(oldValue)
      html.classList.add(newValue)
    },
  },
  mounted() {
    this.$router.replace('/')
  },
  methods: {
    toastActionClick(act) {
      if (typeof act.cb === 'function') {
        act.cb(act)
      }
      this.uiStore.toast.show = false
    },
  },
}
</script>
