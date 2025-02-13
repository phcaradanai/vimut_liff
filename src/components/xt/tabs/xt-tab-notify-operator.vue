<template>
  <div class="h-full">
    <div
      v-for="collapse in Object.keys(inputs)"
      :key="collapse"
      class="collapse"
    >
      <div
        :class="{ 'open': show == collapse }"
        class="collapse-header my-2 p-2 border flex flex-row"
        @click="toggleCollapse(collapse)"
      >
        <p class="w-full">
          {{ collapse }}
        </p>
        <span class="m-icon">
          {{ show == collapse ? 'expand_less' : 'expand_more' }}
        </span>
      </div>
      <div
        v-show="show == collapse"
        class="collapse-body p-2 border"
      >
        <xt-tab-general
          :inputs="inputs[collapse]"
          :formdata="formdata"
        ></xt-tab-general>
        <!-- <div
          v-for="input in inputs[collapse]"
          :key="input.id"
          class="flex my-1"
        >
          <label for="">{{ input.text }}</label>
          <div
            class="w-full"
            v-if="input.type === 'duty'"
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
                :style="required[item.id] ? 'border: 0.5px solid red ;' : ''"
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
          <input
            v-else
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
        </div> -->
      </div>
    </div>
    <!-- {{ inputs }}
    Noti Operator -->
  </div>
</template>

<script>
export default {
  props: {
    inputs: {
      type: Object,
      required: true,
    },
    formdata: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      show: '',
      form: this.formdata,
    }
  },
  methods: {
    toggleCollapse(key) {
      if (this.show === key) {
        this.show = ''
      } else {
        this.show = key
      }
    },
  },
}
</script>

<style scoped>
.collapse {
  @apply transition-all duration-200;
  @apply w-full;

  .collapse-header {
    @apply shadow;
    @apply bg-gray-50;

    &.open {
      @apply bg-gray-200;

    }

    &:hover {
      @apply bg-gray-200;
    }
  }

  .collapse-body {
    @apply overflow-y-auto;
    @apply shadow;
  }
}
</style>
