<template>
  <div class="ui-pager flex items-center">
    <div class="px-3 flex-shrink-0" :style="`color: ${textColor} ;`" v-show="displayRows">
      Display row {{ page * perPage + 1 }} - {{ perPage === -1 ? totalRows : Math.min(totalRows, (page + 1) * perPage) }}
    </div>
    <div class="flex-shrink-0 px-3 flex min-w-[120px] h-10 items-center" v-show="selectPerPage">
      <select :value="perPage" class="flex-grow block h-8" @change="perPageChange">
        <option :value="-1" v-if="allPerPage">
          {{ $t('ui-pager.all') }}
        </option>
        <option v-for="p in perPageList" :key="p" :value="p">
          {{ p }}
        </option>
      </select>
    </div>
    <div class="flex-grow flex" v-show="scrollPerPage">
      <button class="ml-1 w-8 h-8 rounded-lg disabled:(bg-gray-200) p-0 flex justify-center items-center" :disabled="page <= 0" @click="goto(0)">
        <span class="m-icon">first_page</span>
      </button>
      <button class="ml-1 w-8 h-8 rounded-lg disabled:(bg-gray-200) p-0 flex justify-center items-center" :disabled="page <= 0" @click="goto(page - 1)">
        <span class="m-icon">chevron_left</span>
      </button>
      <button
        v-for="p in pageList" :key="p" @click="goto(p.page)" class="ml-1 w-8 h-8 rounded-lg disabled:(bg-gray-200) p-0 flex justify-center items-center"
        :class="{ 'font-bold': p.page === page }"
        :style="`color: ${textColor} ;`"
      >
        {{ p.t }}
      </button>
      <button class="ml-1 w-8 h-8 rounded-lg disabled:(bg-gray-200) p-0 flex justify-center items-center" :disabled="page >= totalPages - 1" @click="goto(page + 1)">
        <span class="m-icon">chevron_right</span>
      </button>
      <button class="ml-1 w-8 h-8 rounded-lg disabled:(bg-gray-200) p-0 flex justify-center items-center" :disabled="page >= totalPages - 1" @click="goto(totalPages - 1)">
        <span class="m-icon">last_page</span>
      </button>
    </div>
  </div>
</template>

<script>
import { defineComponent, computed } from 'vue'

export default defineComponent({
  props: {
    totalRows: {
      type: Number,
      default: 0,
    },
    page: {
      type: Number,
      default: 0,
    },
    perPage: {
      type: Number,
      default: 100,
    },
    perPageList: {
      type: Array,
      default() {
        return [
          25,
          100,
          500,
        ]
      },
    },
    allPerPage: {
      type: Boolean,
      default: false,
    },
    pageListSize: {
      type: Number,
      default: 5,
    },
    displayRows: {
      type: Boolean,
      default: true,
    },
    selectPerPage: {
      type: Boolean,
      default: true,
    },
    scrollPerPage: {
      type: Boolean,
      default: true,
    },
    textColor: {
      type: String,
      default: 'black',
    },
  },

  emits: [
    'update:perPage',
    'update:page',
  ],

  setup(props, context) {
    const totalPages = computed(() => {
      if (props.perPage === -1) {
        return 1
      }
      return Math.ceil(props.totalRows / props.perPage)
    })

    const goto = (page) => {
      context.emit('update:page', page)
    }

    const pageList = computed(() => {
      let out = []
      // if (props.page > props.pageListSize) {
      //   out.push({ t: '\u2026', page: props.page - props.pageListSize })
      // }

      let from = Math.max(0, Math.min(totalPages.value - props.pageListSize * 2 - 1, props.page - props.pageListSize))
      let to = Math.min(totalPages.value - 1, from + props.pageListSize * 2)
      for (let p = from; p <= to; p++) {
        out.push({ t: String(p + 1), page: p })
      }
      // if (props.page < totalPages.value - props.pageListSize) {
      //   out.push({ t: '\u2026', page: props.page + props.pageListSize })
      // }
      return out
    })

    const perPageChange = v => {
      context.emit('update:page', 0)
      context.emit('update:perPage', parseInt(v.target.value))
    }

    return {
      // computed
      totalPages,
      pageList,
      // methods
      goto,
      perPageChange,
    }
  },
})
</script>
