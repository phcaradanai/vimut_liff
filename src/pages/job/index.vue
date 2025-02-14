<template>
  <div class="flex flex-col">
    <div class="flex flex-col">
      <pre>{{ selectedJob }}</pre>
      <pre>{{ appStore.token }}</pre>

      <pre>xxxx{{ jobStore.paramId }}</pre>
    </div>
  </div>
</template>

<script>
import { mapWritableState } from 'pinia'

import { useJobStore } from '@/store/job-store'
import { useAppStore } from '@/store/app-store.js'

export default {
  data() {
    const jobStore = useJobStore()
    const appStore = useAppStore()

    return {
      jobStore,
      appStore,
    }
  },
  computed: {
    ...mapWritableState(useJobStore, ['selectedJob']),
  },
}
</script>
