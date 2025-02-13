import { defineStore } from 'pinia'

export const useUiStore = defineStore('ui', {
  state() {
    return {
      toast: {
        show: false,
        message: '',
        duration: 1000,
        actions: [],
        timer: null,
      },
    }
  }, // state

  actions: {
    showToast(message, duration, actions) {
      this.toast.message = message
      this.toast.duration = Math.min(duration ?? 3000, 3000)
      this.toast.actions = actions ?? [{ id: 'close', text: 'OK' }]
      this.toast.show = true
      this.toast.timer = setTimeout(() => {
        this.toast.show = false
      }, this.toast.duration)
    },
  }, // actions
})
