<template>
  <ul class="ui-list py-2">
    <template v-for="item in items" :key="item.id">
      <slot v-if="item.type === 'sep'" name="sep" :item="item">
        <hr>
      </slot>
      <slot v-else name="list-item" :item="item">
        <ui-list-item
          :item="item"
          :expanded="expanded"
          @toggle="x => $emit('toggle', x)"
          @item-click="x => $emit('item-click', x)"
          @item-toggle="itemToggle"
        ></ui-list-item>
      </slot>
    </template>
  </ul>
</template>

<script>
export default {
  props: {
    items: {
      type: Array,
      default() {
        return []
      },
      required: true,
    },
    expanded: {
      type: Object,
      default() {
        return {}
      },
    },
  },

  emits: [
    'toggle',
    'item-click',
    'item-toggle',
  ],

  methods: {
    itemToggle(item) {
      this.$emit('item-toggle', item)
    },
  },
}

</script>
