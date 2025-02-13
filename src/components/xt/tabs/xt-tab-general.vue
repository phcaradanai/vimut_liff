<template>
  <div
    v-for="input in inputs"
    :key="input.id"
    class="flex my-1"
  >
    <label
      :for="input.id"
      class="w-40 border-b-width-[1px] border-b-blue-400"
    >
      {{ input.text }}
    </label>
    <textarea
      :ref="input.id"
      v-if="input.type === 'textarea'"
      :id="input.id"
      rows="3"
      class="ui-input flex-grow h-[100px]"
      v-model="form[input.id]"
    />
    <select
      v-else-if="input.type === 'select'"
      v-model="form[input.id]"
      :id="input.id"
      :ref="input.id"
    >
      <option
        v-for="opt in input.list?.() || []"
        :key="opt.value"
        :value="opt.value"
        :disabled="opt.disabled"
        :selected="opt.selected"
      >
        {{ opt.text }}
      </option>
    </select>
    <div
      class="w-full"
      v-else-if="input.type === 'duty'"
    >
      <div
        class="grid gap-2 grid-rows-1 grid-cols-4 py-1"
        v-for="formInput in input.forms"
        :key="formInput"
      >
        <label for="">
          {{ formInput.text }}
        </label>
        <input
          class="ui-input flex-grow"
          v-for="item in formInput.input"
          :key="item.id"
          :type="item.type"
          :placeholder="item.id"
          :id="item.id"
          :required="item.required"
          :min="form[item?.min]"
          :max="form[item?.max]"
          :maxlength="item.maxlength"
          :step="item.step"
          v-model="form[item.id]"
        >
        <button
          class="ui-btn"
          @click="() => {
            formInput?.input?.forEach(el => {
              delete form[el.id]
            })
            form[formInput.id] = null
          }"
        >
          RESET
        </button>
      </div>
    </div>
    <div
      class="border flex w-full"
      v-else-if="input.type == 'radio'"
    >
      <!-- {{ form }} -->
      <div
        class="flex flex-row items-center"
        v-for="item in input?.list()"
        :key="item.text"
      >
        <input
          :type="input.type"
          class="w-[16px] mx-2"
          :id="input.id + item.value"
          :ref="item.id"
          :required="item.required"
          :min="item.min"
          :max="item.max"
          :maxlength="item.maxlength"
          :step="item.step"
          :name="input.id"
          :checked="form[input.id] == item.value"
          @change="form[input.id] = item.value"
        >
        <label
          class="w-[50px]"
          :for="input.id + item.value"
        >{{ item.text }}</label>
      </div>
    </div>
    <div
      class="border grid grid-cols-2 w-full"
      v-else-if="input.type == 'checkbox'"
    >
      <!-- {{ $util.unflattenObj(form) }} -->
      <div
        class="flex flex-row items-center"
        v-for="item in input?.list()"
        :key="item.text"
      >
        <input
          :type="input.type"
          class="w-[16px] mx-2"
          :id="input.id + item.value"
          :ref="item.id"
          :required="item.required"
          :min="item.min"
          :max="item.max"
          :maxlength="item.maxlength"
          :step="item.step"
          :name="input.id"
          :value="item.value"
          :checked="operatorsExists(input.index, item.value)"
          @change="(event) => operatorsHandler(input, item, event.target.value)"
        >
        <label
          class="w-[50px]"
          :for="input.id + item.value"
        >{{ item.text }}</label>
      </div>
    </div>
    <slot :name="`input-${input.type}`">
      <input
        :type="input.type || 'text'"
        class="ui-input flex-grow"
        :id="input.id"
        :ref="input.id"
        :required="input.required"
        :min="input.min"
        :max="input.max"
        :maxlength="input.maxlength"
        :step="input.step"
        v-model="form[input.id]"
      >
    </slot>
  </div>
</template>

<script>
export default {
  props: {
    inputs: {
      type: Object,
      requried: true,
    },
    formdata: {
      type: Object,
      required: true,
    },
  },

  emits: ['updateForm'],

  data() {
    return {
      form: this.formdata,
    }
  },

  methods: {
    operatorsHandler(input, item, value) {
      value = parseInt(value)
      let data = this.$util.unflattenObj(this.form)
      let operators = data.config[input.index]?.operators
      if (operators.includes(value)) {
        operators = operators.filter(li => li !== value)
      } else {
        operators.push(value)
      }
      this.form = this.$util.flattenObj(data)
      console.log(data)
    },
    operatorsExists(index, value) {
      return this.$util.unflattenObj(this.form).config[index]?.operators?.includes(value)
    },
  },
}
</script>
