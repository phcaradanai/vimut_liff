<template>
  <li class="ui-list-item flex flex-col :not:last-of-type:(border-b-[1px] border-b-light-900)">
    <router-link class="flex px-4 gap-4" :to="item.to || ''" :exact-active-class="item.to ? 'exact-active' : ''" @click="doClick">
      <slot>
        <slot v-if="item.icon" name="item-icon" :item="item">
          <div class="flex-shrink-0 flex items-center">
            <div class="m-icon">
              {{ item.icon }}
            </div>
          </div>
        </slot>
        <slot v-if="item.text || item.header" name="item-content">
          <div v-if="item.header" class="h-6 leading-6 font-bold text-sm">
            {{ item.text }}
          </div>
          <div v-else-if="item.text" class="flex-grow h-10 leading-10">
            {{ item.text }}
          </div>
        </slot>
        <slot v-if="item.actions?.length" name="item-actions">
          <div class="flex">
            <div v-for="act in item.actions" :key="act.id">
              {{ act.id }}
            </div>
          </div>
        </slot>
      </slot>
      <button v-if="item.items?.length" class="flex-shrink-0">
        <span class="m-icon">{{ expanded[item.id] ? 'expand_more' : 'chevron_right' }}</span>
      </button>
    </router-link>
    <ui-list
      v-if="item.items?.length"
      v-show="expanded[item.id]"
      class="border-1 border-gray-500"
      :items="item.items"
      @item-click="x => $emit('item-click', x)"
      @item-toggle="x => $emit('item-toggle', x)"
    >
    </ui-list>
  </li>
</template>

<script>
export default {
  props: {
    item: {
      type: Object,
      required: true,
    },
    expanded: {
      type: Object,
      default() {
        return {}
      },
    },
  }, // props

  emits: [
    'toggle',
    'item-click',
    'item-toggle',
  ],

  methods: {
    doClick(e) {
      e.preventDefault()
      if (this.item.items?.length) {
        this.$emit('toggle', this.item.id)
      } else if (typeof this.item.click === 'function') {
        this.item.click(this.item)
      } else if (typeof this.item.toggle === 'function') {
        this.item.toggle()
      }
      this.$emit('item-click', this.item)
    },
  },
}
</script>
