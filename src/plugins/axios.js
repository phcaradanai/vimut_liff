import defaultAxios from '@/lib/axios.js'
import { useAppStore } from '@/store/app-store.js'
import { useUiStore } from '@/store/ui-store'

export const install = ({ app, router }) => {
  defaultAxios.interceptors.response.use(res => {
    // Do something before request is sent
    if (res.data?.token === '') {
      useAppStore().setToken('')
      router.replace('/auth')
    }

    if (res.data.error) {
      useUiStore().showToast(res.data.error, 5000, [
        {
          id: 'close',
          text: 'OK',
        },
      ])
    }

    return res
  })
  app.config.globalProperties.$axios = defaultAxios
  app.config.globalProperties.$http = defaultAxios
}
