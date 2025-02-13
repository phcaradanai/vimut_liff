<template>
  <div class="flex h-12 px-3 pr-1 bg-gray-300 items-end justify-end border-b-width-[2px] border-b-blue-300">
    <div class="flex-grow flex gap-1  overflow-x-hidden">
      <div
        v-for="tab in tabs"
        :key="tab"
        :ref="`tab-${tab}`"
        class="cursor-default h-10 leading-9 px-3 min-w-[160px] bg-white border-t-width-[2px] border-t-transparent border-b-width-[2px] border-b-transparent hover:(bg-gray-100)"
        :class="{'!border-b-blue-300': selectedTab === tab}"
        @click="$evt => onTabClick($evt, tab)"
      >
        <slot :name="tab">
          {{ tab }}
        </slot>
      </div>
    </div>
    <div class="flex-shrink-0 flex items-center px-1 py-2">
      <ui-btn icon="chevron_left" class="bg-white disabled:(bg-gray-200)" @click="gotoTab(-1)" :disabled="selectedIndex <= 0" />
      <ui-btn icon="chevron_right" class="bg-white disabled:(bg-gray-200)" @click="gotoTab(1)" :disabled="selectedIndex >= tabs.length - 1" />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    tabs: {
      type: Array,
      default() {
        return []
      },
    },

    selectedTab: {
      type: String,
    },
  },

  emits: [
    'update:selectedTab',
  ],

  computed: {
    selectedIndex() {
      return this.tabs.findIndex(x => x === this.selectedTab)
    },
  },

  watch: {
    selectedTab(v) {
      let el = this.$refs[`tab-${v}`]
      if (el) {
        if (Array.isArray(el)) {
          el[0].scrollIntoView()
        } else {
          el.scrollIntoView()
        }
      }
    },
  },

  methods: {
    onTabClick(el, tab) {
      el.target.scrollIntoView()
      this.$emit('update:selectedTab', tab)
    },

    gotoTab(dir) {
      let idx = Math.min(this.tabs.length - 1, Math.max(0, this.selectedIndex + dir))
      this.$emit('update:selectedTab', this.tabs[idx])
    },
  }, // methods
}
</script>
