import { defineStore } from 'pinia'

import axios from '@/lib/axios.js'
import { genLookup, packToArray } from '@/lib/util.js'
import { useAppStore } from '@/store/app-store.js'
import { MqttClient } from '@/lib/mqtt-worker'

export const useMasterStore = defineStore('master', {
  // arrow function recommended for full type inference
  state() {
    return {
      projects: [],
      receptors: [],
      xentemp: [],
      notiProfiles: [],
      tempProfiles: [],
      operators: [],
      roles: [],
      users: [],
    }
  }, // state

  getters: {
    receptorLookup(state) {
      return genLookup(state.receptors, 'id')
    },

    xentempLookup(state) {
      return genLookup(state.xentemp, 'id')
    },
  }, // getters

  actions: {
    async fetchMaster() {
      try {
        let { data } = await axios({
          methods: 'GET',
          url: '/api/master',
        })
        for (let tableName of Object.keys(data.data)) {
          if (!this[tableName]) {
            continue
          }
          this[tableName] = packToArray(data.data[tableName])
        }
      } catch (e) {
        console.log('error', e.message)
      }
    }, // fetchMaster

    async updateMaster(data) {
      await axios({
        method: 'POST',
        url: '/api/master',
        data,
      })
    }, // updateMaster

    subscribeChange() {
      const profile = useAppStore().profile
      if (!profile.project.config?.mqtt) {
        console.log('NO MQTT config')
        return
      }
      let mqttClient = MqttClient('default', profile.project.config.mqtt)
      mqttClient.subscribe('ws/0000/a', this.onChange)
    }, // subscribeChange

    onChange(topic, payload) {
      // console.log('MQTT:', topic, payload)
      const profile = useAppStore().profile
      const user = profile.user
      let obj = payload
      for (let table of Object.keys(obj)) {
        if (!this[table]) {
          continue
        }
        if (obj[table].upd?.length) {
          for (const data of obj[table].upd) {
            // filter only row that match projectId
            if (table === 'project' && (user.config.isAdmin === 1 || data.id === user.projectId)) {
              // ok
            } else if (data.projectId && user.projectId && data.projectId !== user.projectId) {
              // skip
              continue
            }
            let index = this[table].findIndex(item => item.id === data.id)
            if (index >= 0) {
              this[table].splice(index, 1, { ...this[table][index], ...data }) // merge
            } else {
              this[table].push(data)
            }
          }
        }
        if (obj[table].del?.length) {
          for (const id of obj[table].del) {
            let index = this[table].findIndex(item => item.id === id)
            this[table][index].isActive = 'N'
          }
        }
      }
    },
  }, // actions
})
