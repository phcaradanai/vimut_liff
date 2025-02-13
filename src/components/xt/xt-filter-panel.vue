<template>
  <div class="flex flex-shrink-0 px-3 py-2 gap-2">
    <div class="flex-grow flex gap-2">
      <div v-for="item in filterItems" :key="item.id" class="flex flex-col">
        <label class="text-xs leading-4" :for="`filter-${item.id}`">{{ $t(`filter.${item.text.toLowerCase()}`) }}</label>
        <!-- <xt-location-selector
          v-if="item.type === 'location'"
          :id="`filter-${item.id}`"
          class="border-[1px] px-2 flex-grow min-w-50"
          :value="filter[item.id]"
          @change="$emit('update:filter', { ...filter, [item.id]: $event.target.value })"
        /> -->
        <input
          :type="item.type || 'text'"
          :id="`filter-${item.id}`"
          :value="filter[item.id]"
          @input="$emit('update:filter', { ...filter, [item.id]: $event.target.value })"
          @focus="$event.target.select()"
        >
      </div>
      <div v-if="Object.values(filterItems).length || searchBtn" class="flex flex-col justify-end">
        <ui-btn icon="search" @click="$emit('search', filter)">
          <span class="px-2">{{ $t('filter.button.search') }}</span>
        </ui-btn>
      </div>
    </div>
    <div class="flex-shrink-0 flex gap-2">
      <div v-for="action in actions" :key="action.event" class="flex flex-col justify-end">
        <ui-btn :icon="action.icon" @click="$emit(action.event)">
          <span class="px-2">{{ $t(`filter.button.${action.text.toLowerCase()}`) }}</span>
        </ui-btn>
      </div>
    </div>
  </div>
</template>
<script>
import dayjs from 'dayjs'

export default {
  props: {
    filter: {
      type: Object,
      default() {
        let today = dayjs().format('YYYY-MM-DD')
        return {
          dateFrom: today,
          dateTo: today,
          keyword: '',
        }
      },
    },

    filterItems: {
      type: Array,
      default() {
        return [
          {
            id: 'dateFrom',
            text: 'date.from',
            type: 'date',
          },
          {
            id: 'dateTo',
            text: 'date.to',
            type: 'date',
          },
          {
            id: 'keyword',
            text: 'Keyword',
            type: 'text',
          },
        ]
      },
    },

    actions: {
      type: Array,
      default() {
        return [
          {
            icon: 'file_download',
            text: 'export',
            event: 'export',
          },
        ]
      },
    },
    searchBtn: {
      type: Boolean,
      default () {
        return true
      },
    },
  },

  emits: [
    'update:filter',
    'search',
    'export',
  ],
}
</script>
