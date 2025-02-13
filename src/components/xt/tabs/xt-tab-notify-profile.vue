<template>
  <div class="grid grid-rows-[1fr] grid-cols-[1fr]">
    <!-- <div class="w-[600px] h-[300px] overflow-y-scroll">
      {{ $util.unflattenObj(formdata) }}
    </div> -->
    <div class="table-wrapper">
      <table class="w-full">
        <thead class="border">
          <tr>
            <th>
              Type
            </th>
            <th>
              Operators
            </th>
            <th>
              Active
            </th>
            <th>
              Action
            </th>
          </tr>
        </thead>
        <tbody class="border">
          <tr
            v-for="(item, key) in $util.unflattenObj(formdata)?.config"
            :key="key"
          >
            <td>
              {{ item.type }}
            </td>
            <td>
              {{
                item.operators?.map(e =>
                  operators[e.toString()]?.displayName ?? `unknow ${e}`
                ).join()
              }}
            </td>
            <td class="text-center">
              <span
                v-if="item.active"
                class="m-icon text-green-500"
              >
                done
              </span>
              <span
                v-if="!item.active"
                class="m-icon text-red-500"
              >
                clear
              </span>
            </td>
            <td class="flex flex-row justify-center">
              <ui-btn
                type="button"
                class="w-50% mx-1"
                icon="edit"
                @click="selectedIndex = key"
              ></ui-btn>
              <ui-btn
                type="button"
                class="w-50% mx-1"
                icon="content_copy"
              ></ui-btn>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div
      v-if="selectedIndex !== -1"
      class="form-editor"
    >
      <slot></slot>
      <xt-tab-general
        :inputs="customMethods.generateForm(selectedIndex)"
        :formdata="formdata"
      ></xt-tab-general>
    </div>
  </div>
</template>

<script>
import { useMasterStore } from '../../../store/master-store'

const masterStore = useMasterStore()
export default {
  props: {
    inputs: {
      type: Object,
      requried: true,
    },
    customMethods: {
      type: Object,
    },
    formdata: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      operators: (() => {
        let out = {}
        masterStore.operators.forEach(e => {
          out[e.id] = e
        })
        return out
      })(),
      selectedIndex: -1,
      input: {},
    }
  },
}
</script>

<style scoped>
.table-wrapper {
  @apply border;
  @apply my-2;

  tbody {
    overflow-y: scroll;
    max-height: 100%;
  }
}
</style>
