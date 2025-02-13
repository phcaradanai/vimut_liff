<route lang="yaml">
meta:
  layout: default
</route>

<template>
  <div
    class="top-0 bottom-0 left-0 right-0 absolute bg-white flex flex-col items-center justify-center"
  >
    <p class="text-5xl">XENGISTIC</p>
    <!-- <img
      :src="liffProfile.pictureUrl"
      alt="pictureUrl"
      class="rounded-full w-20"
    />

    <p>{{ liffProfile.statusMessage }}</p>
    <p>{{ liffProfile.displayName }}</p> -->
    <!-- <p>{{ liffProfile.userId }}</p> -->

    <!-- <p>access token: {{ liffEnv.accessToken }}</p> -->
  </div>
</template>

<script>
import { mapState } from 'pinia'

import { useAppStore } from '@/store/app-store'
import { useJobStore } from '@/store/job-store'
import { useLiffStore } from '@/store/liff-store'

export default {
  data() {
    const appStore = useAppStore()
    const jobStore = useJobStore()
    const liffStore = useLiffStore()

    return {
      appStore,
      jobStore,
      liffStore,
    }
  },

  async mounted() {
    await this.liffStore.initialLiff()
    const urlParams = new URLSearchParams(window.location.search)
    let paramData = JSON.parse(decodeURIComponent(urlParams.get('data')))
    this.jobStore.paramId = paramData
    this.jobStore.getJob(paramData).then(() => {
      this.$router.replace('/job')
    })
  },
  computed: {
    ...mapState(useLiffStore, [
      'liffProfile',
      'liffEnv',
      'liffContext',
      'liffFriendship',
    ]),
    // ...mapState(useJobStore, ['selectedJob']),
  },

  methods: {},
}
</script>
