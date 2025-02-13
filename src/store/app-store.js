import { defineStore } from 'pinia'
import { useStorage } from '@vueuse/core'
import axios from '@/lib/axios.js'
import i18n from '@/lib/i18n.js'

export const useAppStore = defineStore('app', {
  state() {
    return {
      lang: useStorage('lang', 'en'),
      theme: useStorage('theme', 'light'),
      showNav: false,
      token: useStorage('token', '', window.sessionStorage),
      profile: {
        project: {},
        user: {},
      },
      acls: {},
    }
  }, // state

  getters: {
  },

  actions: {
    toggleNav() {
      this.showNav = !this.showNav
    },

    setLang(lang) {
      i18n().global.locale.value = lang
      this.lang = lang
    },

    setToken(token) {
      this.token = token
      if (token) {
        axios.defaults.headers.common.Authorization = `Bearer ${token}`
      } else {
        delete axios.defaults.headers.common.Authorization
      }
    }, // setToken

    async fetchToken() {
      try {
        let { data } = await axios({
          method: 'get',
          url: '/api/auth/token',
        })
        if (typeof data.token !== 'undefined') {
          this.setToken(data.token)
        }
      } catch (err) {
        console.log(err.message)
      }
    }, // fetchToken

    async fetchProfile() {
      try {
        let { data } = await axios({
          method: 'get',
          url: '/api/auth/profile',
        })
        if (data.data.project) {
          this.profile.project = data.data.project
        }
        if (data.data.user) {
          this.profile.user = data.data.user
        }
        if (data.data.acls) {
          this.acls = data.data.acls
        }
        if (data.data.symbols) {
          this.symbols = data.data.symbols
        }
      } catch (err) {
        console.log(err.message)
      }
    }, // fetchProfile
  }, // actions
})
