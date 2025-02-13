<template>
  <ul>
    <li v-for="key in Object.keys(info)" :key="key">
      <div class="flex gap-3 leading-6 border-b-1 border-t-1 border-t-transparent hover:(bg-gray-100)">
        <div class="flex-grow w-1/2 truncate" :style="{ paddingLeft: (level * 16) + 'px' }">
          {{ key }}
        </div>
        <div class="flex-grow w-1/2 truncate font-mono">
          <template v-if="typeof info[key] &#33;== 'object'">
            {{ info[key] }}
          </template>
          <template v-else>
            <i class="text-gray-500">({{ Object.keys(info[key]).length }})</i>
          </template>
        </div>
      </div>
      <xt-info-viewer v-if="typeof info[key] === 'object'" :info="info[key]" :level="level + 1"></xt-info-viewer>
    </li>
  </ul>
</template>

<script>
export default {
  props: {
    info: {
      type: Object,
      default() {
        return {

        }
      },
    },
    level: {
      type: Number,
      default: 0,
    },
  }, // props
}
</script>
