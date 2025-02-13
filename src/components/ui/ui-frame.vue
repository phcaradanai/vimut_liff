<template>
  <div ref="frame" class="ui-frame" @keydown.stop="onKeydown">
    <!-- <input class="no-focus" @focus="onFocusFirst"> -->
    <slot />
    <!-- <input class="no-focus" @focus="onFocusLast"> -->
  </div>
</template>

<script>
const FOCUSABLE_SELECTOR = 'input, select, textarea, button, [href], [tabindex]'

export default {
  props: {
    skipReadonly: {
      type: Boolean,
      default: false,
    },
  },

  methods: {
    selectOrFocus(el) {
      if (el.classList.contains('no-focus') ||
        el.attributes.tabindex?.value === '-1' ||
        el.disabled ||
        (this.skipReadonly && el.readOnly)) {
        return false
      }

      if (typeof el.select === 'function') {
        setTimeout(() => {
          el.select()
        })
        return true
      } else if (typeof el.focus === 'function') {
        setTimeout(() => {
          el.focus()
        })
        return true
      }

      return false
    },

    onFocusFirst() {
      let frameEl = this.$refs.frame
      if (!frameEl) {
        return
      }

      let els = frameEl.querySelectorAll(FOCUSABLE_SELECTOR)
      for (let i = els.length - 1; i >= 0; i--) {
        let el = els[i]
        if (this.selectOrFocus(el)) {
          return
        }
      }
    },

    onFocusLast() {
      let frameEl = this.$refs.frame
      if (!frameEl) {
        return
      }

      let els = frameEl.querySelectorAll(FOCUSABLE_SELECTOR)
      for (let el of els) {
        if (this.selectOrFocus(el)) {
          return
        }
      }
    },

    onKeydown(e) {
      if (e.keyCode !== 13 && e.keyCode !== 9) {
        return
      }
      if (e.keyCode === 13 && e.target.tagName === 'BUTTON') {
        return
      }
      let frameEl = this.$refs.frame
      let els = frameEl.querySelectorAll(FOCUSABLE_SELECTOR)
      let len = els.length
      let idx = -1
      for (let i = 0; i < len; i++) {
        if (els[i] === e.target) {
          idx = i
          break
        }
      }
      if (idx === -1) {
        console.log('not enter on a focusable element')
        return
      }
      let dir = e.shiftKey ? -1 : 1
      for (let i = 1; i < len; i++) {
        let el = els[(len + idx + i * dir) % len]
        if (this.selectOrFocus(el)) {
          break
        }
      }
      e.stopPropagation()
    },
  },
}
</script>
