<template>
  <div class="p-2 flex flex-col h-full">
    <div class="flex">
      <div class="flex-grow leading-10 px-3 text-lg">
        <code class="font-bold mr-2">
          {{ entity?.code }}
        </code>
        {{ entity?.displayName }}
      </div>
      <div
        class="flex-shrink-0 leading-10 flex justify-center items-center pr-1"
      >
        <ui-btn
          icon="close"
          @click="$emit('close')"
        />
      </div>
    </div>

    <div class="flex flex-col h-[calc(100%-40px)]">
      <ui-tabs
        :tabs="tabList"
        v-model:selectedTab="selectedTab"
      >
        <template #default="{ tab }">
          {{ tab }}
        </template>
      </ui-tabs>
      <div class="p-3">
        <slot></slot>
        <!-- <div v-show="selectedTab !== 'info'">
          <ui-form :disabled="busy">
            <div class="flex justify-end">
              <div class="flex-grow">
                {{ selectedTab }}
              </div>
              <div class="flex-shrink-0 flex gap-2">
                <ui-btn
                  icon="save"
                  @click="onSave"
                >
                  Save
                </ui-btn>
                <ui-btn icon="cancel">
                  Reset
                </ui-btn>
              </div>
            </div>
            <xt-tab-notify-operator
              v-if="selectedTab === 'NotifyOperator'"
              :selected-tab="selectedTab"
              :inputs="inputs[selectedTab]"
              :formdata="form"
            >
            </xt-tab-notify-operator>
            <xt-tab-notify-profile
              v-if="selectedTab === 'NotifyProfile'"
              :inputs="inputs[selectedTab]"
              :custom-methods="inputs.methods()"
              :entity="entity"
              :formdata="form"
            >
            </xt-tab-notify-profile>
            <div
              v-else
              class="py-3 flex flex-col"
            >
              <xt-tab-general
                :inputs="inputs[selectedTab]"
                :formdata="form"
              ></xt-tab-general>
            </div>
          </ui-form>
        </div>
        <div v-show="selectedTab === 'info'">
          <div class="overflow-auto h-[750px]">
            <table class="w-full">
              <tr
                class="leading-8 px-2 py-0 border-solid border-b-1 truncate"
                v-for="key in Object.keys(getKey(selectedTab) || {})"
                :key="key"
              >
                <td v-if="!(/noti/.test(key))">
                  {{ key }}
                </td>
                <td v-if="!(/noti/.test(key))">
                  {{ getKey(selectedTab)[key] }}
                </td>
              </tr>
            </table>
          </div>
        </div> -->
        <!-- <div v-show="selectedTab === 'info'">
          <div class="overflow-auto h-[750px]">
            <table class="w-full">
              <tr
                class="leading-8 px-2 py-0 border-solid border-b-1 truncate"
                v-for="key in Object.keys(info || {})"
                :key="key"
              >
                <td>
                  {{ key }}
                </td>
                <td>
                  {{ info[key] }}
                </td>
              </tr>
            </table>
          </div>
        </div> -->
        <!-- <div v-show="selectedTab === 'data'">
          <ui-form :disabled="busy">
            <div class="py-3 flex flex-col" style="height: 600px; overflow: scroll">
              <div v-for="(row, idx) of rows" :key="idx" class="flex my-1">
                <label class="w-40 border-b-width-[1px] border-b-blue-400">{{ row.key }}</label>
                <label class="ui-input w-full">{{ row.value }}</label>
              </div>
            </div>
          </ui-form>
        </div>-->
        <!-- <div v-show="selectedTab === 'link'">
          <ui-form :disabled="busy" v-if="['edit', 'add'].includes(linkAction)">
            <div class="flex">
              <label class="w-full border-b-width-[1px] border-b-blue-400">{{ linkAction + ' link' }}</label>
              <div class="flex-shrink-0 flex">
                <ui-btn icon="done" @click="doOkLink">
                  ok
                </ui-btn>
                <ui-btn icon="cancel" @click="doCancelLink">
                  cancel
                </ui-btn>
              </div>
            </div>
            <div class="py-3 flex flex-col" style="height: 600px; overflow: scroll">
              <div v-for="(row, idx) of linkFormDefault" :key="row.idx" class="flex my-1">
                <label class="w-40 border-b-width-[1px] border-b-blue-400">{{ row.key }}</label>
                <select
                  v-if="row.type === 'd'"
                  name="typedata2"
                  class="border-[1px] border-black bg-transparent text-base w-80"
                  v-model="linkForm[row.key]"
                  style="color: black; outline: none;"
                  @change="changeLinkFormId"
                >
                  <option
                    class="text-base "
                    style="color: #1F2937;"
                    v-for="opt in row.key === 'code' ? $store.state.entity[linkForm.entityType || ''] || [] : linkReceptorOptions"
                    :key="opt.code"
                    :value="opt.code"
                  >
                    {{ opt.code }}
                  </option>
                </select>
                <label v-else-if="row.type === 'l'" class="ui-input w-113">
                  {{ $store.state.entity[linkForm.entityType || '']?.[linkForm[selectedSubTab === 'linkFrom' ? 'toId' : 'formId'] || '']?.displayName || '' }}
                </label>
                <textarea
                  v-else-if="row.type === 'a'"
                  rows="3"
                  class="ui-input flex-grow h-[100px]"
                  v-model="linkForm[row.key]"
                />
                <input v-else-if="row.type === 'b'" type="checkbox" v-model="linkForm[row.key]" true-value="Y" false-value="N">
                <input
                  v-else
                  :id="idx"
                  class="ui-input flex-grow hover:(bg-yellow-500) invalid:(text-white)"
                  v-model="linkForm[row.key]"
                  autofocus
                >
              </div>
            </div>
          </ui-form> -->
        <!-- <div v-else>
            <div class="flex">
              <div class="flex-grow my-1">
                <label class="border-b-width-[1px] border-b-blue-400" for="typedata">Link Type</label>
                <select
                  name="typedata"
                  class="border-[1px] border-black w-40 bg-transparent text-base"
                  v-model="selectedSubTab"
                  style="color: black; outline: none;"
                  @change="changeLinkType"
                >
                  <option
                    class="text-base "
                    style="color: #1F2937;"
                    v-for="opt in typeOption"
                    :key="opt.key"
                    :value="opt.value"
                  >
                    {{ opt.key }}
                  </option>
                </select>
              </div>
              <div class="flex-shrink-0 flex gap-2">
                <ui-btn icon="add" @click="linkAction = 'add'">
                  Add
                </ui-btn>
                <ui-btn icon="save" @click="doSaveLink">
                  Save
                </ui-btn>
              </div>
            </div>
            <div class="py-3 flex-col">
              <ui-table :cols="cols" :rows="rows">
                <template #[`td-linkType`]="{ row }">
                  <div class="flex justify-center">
                    {{ row.linkType }}
                  </div>
                </template>
                <template #[`td-entityType`]="{ row }">
                  <div class="flex justify-center">
                    {{ row.entityType }}
                  </div>
                </template>
                <template #[`td-code`]="{ row }">
                  <div class="flex justify-center">
                    {{ row.code }}
                  </div>
                </template>
                <template #[`td-displayName`]="{ row }">
                  <div class="flex justify-center">
                    {{ $store.state.entity.all[selectedSubTab === 'linkFrom' ? row.toId : row.fromId || '']?.displayName }}
                  </div>
                </template>
                <template #[`td-actions`]="{ row }">
                  <div class="flex justify-center">
                    <ui-btn icon="edit" @click="doEditLink(row)" />
                  </div>
                </template>
              </ui-table>
            </div>
          </div>
        </div>-->
        <!-- <div v-show="selectedTab === 'event'">
          Events
        </div> -->
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    tableName: String,
    entity: {
      type: Object,
    },
    info: {
      type: Object,
    },
    inputs: {
      type: Object,
      default() {
        return {}
      },
    },
  },

  emits: ['close', 'onSave'],

  data() {
    return {
      busy: false,
      required: {},
      form: JSON.parse(JSON.stringify(this.$util.flattenObj(this.entity) || {})),
      formOrig: JSON.parse(JSON.stringify(this.$util.flattenObj(this.entity) || {})),
      selectedTab: 'general',
    }
  },

  computed: {
    tabList() {
      let out = ['info']
      // if (this.tableName === 'notiProfiles') {
      //   setNotiProfileInputs(this.entity)
      // }
      return Object.keys(this.inputs).filter(e => typeof this.inputs[e] !== 'function').concat(out)
    },
    // info() {
    //   return Object.assign({}, this.$util.flattenObj(this.entity?.info))
    // },
  },

  watch: {
    entity() {
      this.form = JSON.parse(JSON.stringify(this.$util.flattenObj(this.entity) || {}))
    },
  },
  mounted() {
    console.log(this.form)
  },
  methods: {
    /* operatorsHander(input, item, action) {
      Object.keys(this.form).forEach(e => {
        if (new RegExp(input.id).test(e)) {
          delete this.form[e]
        }
      })
      if (action === -1) {
        input.selected = input.selected.filter(e => e.id !== item.id)
        input.data = [...new Set([...input.data, item])]
      }
      if (action === 1) {
        input.data = input.data.filter(e => e.id !== item.id)
        input.selected = [...new Set([...input.selected, item])]
      }
      input.selected.forEach((e, k) => {
        this.form[`${input.id}.${k}`] = e.id
      })
      if (!input.selected.length) {
        this.form[`${input.id}`] = []
      }
    }, */
    getKey(key) {
      return Object.assign({}, this.$util.flattenObj(this.entity?.[key]))
    },
    onClose() {
      this.$emit('close')
    },
    onSave() {
      this.$emit('onSave', {
        ...this.$util.unflattenObj(this.form),
      })
    },
  },
}
</script>
