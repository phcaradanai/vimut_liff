<template>
  <table class="ui-table w-full">
    <slot name="toolbar" />
    <thead>
      <tr>
        <!-- <th class="sticky top-0 bg-light-400 h-8 p-0">
          <div class="border-b-1 border-t-1 border-solid border-b-dark-50 border-t-dark-50">
            <input type="checkbox">
          </div>
        </th> -->
        <th
          v-for="(c, k) of cols"
          :key="`th-${k}`"
          class="sticky top-0 bg-light-400 h-7 leading-7 py-0 px-0 font-normal relative"
          :class="{ 'cursor-default': sortable && c.sortable !== false }"
          :style="{ width: c.width }"
          @click="toggleSort(k)"
        >
          <div class="border-b-1 border-t-1 border-solid border-b-dark-50 border-t-dark-50 truncate">
            <slot :name="`th-${k}`">
              {{ c.text }}
            </slot>
          </div>
          <div v-if="sortable" class="absolute w-6 h-6 cursor-default right-0 top-[50%] mt-[-10px]">
            <span class="material-icons">expand_more</span>
          </div>
        </th>
      </tr>
    </thead>
    <tbody>
      <tr
        v-for="(row, idx) in rows" :key="row[pk || 'id'] || idx"
        class="cursor-default hover:(bg-gray-100) "
        :class="[row === selectedRow || row?.id === selectedRow?.id ? 'bg-gray-200' : '']"
        @click="onRowClick(row)"
      >
        <!-- <td class=" border-b-dark-50  px-2 py-0 border-b-${1px}">
          {{ idx + 1 }}
        </td> -->
        <slot name="tr" :row="row" :idx="idx">
          <td v-for="(c, k) of cols" :key="`td-${k}`" class="leading-8 px-2 py-0 border-solid border-b-1 truncate">
            <slot :name="`td-${k}`" :row="row">
              {{ colValue(row, k) }}
            </slot>
          </td>
        </slot>
      </tr>
    </tbody>
  </table>
</template>

<script>
export default {
  props: {
    id: String,

    rows: {
      type: Array,
      default() {
        return []
      },
    },

    cols: {
      type: Object,
      required: true,
    },

    pk: {
      type: String,
      default: 'id',
    },

    sortable: {
      type: Boolean,
      default: false,
    },

    sortBy: {
      type: String,
      default: 'id',
    },

    sortDir: {
      type: String,
      default: '',
    },

    selectedRow: {
      type: Object,
    },
  }, // props

  emits: [
    'update:selectedRow',
    'update:sort',
    'selectedRow',
  ],

  computed: {
    sortedRows() {
      if (!this.sortBy) {
        return this.rows
      }
      let sortedRows = this.rows.slice()
      sortedRows.sort((a, b) => {
        return a[this.sortBy]
      })
      return sortedRows
    },
  },

  methods: {
    onRowClick(row) {
      this.$emit('update:selectedRow', row)
      this.$emit('selectedRow', row)
    },

    colValue(row, key) {
      let keyList = key.split('.')
      let v = row
      for (let k of keyList) {
        v = v[k]
      }
      return v
    },

    toggleSort(key) {
      if (this.sortBy === key) {
        this.$emit('update:sort', {
          sortBy: this.sortBy,
          sortDir: this.sortDir === 'a' ? 'd' : 'a',
        })
      } else {
        this.$emit('update:sort', {
          sortBy: key,
          sortDir: 'a',
        })
      }
    },
  },
}
</script>
