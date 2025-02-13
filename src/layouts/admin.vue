<template>
  <router-view></router-view>
  <app-nav></app-nav>
</template>

<script>
import { useAppStore } from '@/store/app-store.js'
import { useMasterStore } from '@/store/master-store.js'
import axios from '@/lib/axios.js'
import { useAclStore } from '@/store/acl-store.js'

let timer

export default {
  async beforeRouteEnter(to, from, next) {
    // return next()
    const appStore = useAppStore()
    const token = appStore.token
    if (!token) {
      console.log('TOKEN GONE!!!')
      delete axios.defaults.headers.common.Authorization
      return next('/auth')
    }
    axios.defaults.headers.common.Authorization = `Bearer ${token}`

    const masterStore = useMasterStore()

    await Promise.all([
      appStore.fetchProfile(),
      masterStore.fetchMaster(),
    ])

    masterStore.subscribeChange()

    // // TODO: check profile
    clearInterval(timer)
    timer = setInterval(() => {
      appStore.fetchToken()
    }, 300_000) //  5min 300000
    // TODO: redirect

    next()
  },

  beforeRouteUpdate(to, from) {
    let page = to.matched[to.matched.length - 1]?.components.default
    if (page && page.acl) {
      if (!useAclStore().can(page.acl)) {
        useAppStore().setToken('')
        return this.$route.replace('/auth/signin')
      }
    }
  },
}
</script>
