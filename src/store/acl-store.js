import { defineStore } from 'pinia'
import { useAppStore } from './app-store.js'
import { can as aclCan } from '@/lib/acl'

export const useAclStore = defineStore('acl', {
  actions: {
    can(rights) {
      const appStore = useAppStore()
      const listRightSys = ['projects', 'modules']
      if ((listRightSys.includes(Object.keys(rights)[0])) && appStore.profile?.isSysAdmin !== 'Y') {
        return false
      }
      if (rights.sysadmin && appStore.profile?.isSysAdmin !== 'Y') {
        return false
      }
      if (appStore.profile?.isSysAdmin === 'Y' || appStore.profile?.isProjectAdmin === 'Y') {
        return true
      }

      for (const module of Object.keys(rights)) {
        if (module === 'sysadmin') {
          continue
        }
        let acls = appStore.acls[module]
        if (!acls) {
          return false
        }

        let ok = aclCan(acls, rights[module])
        if (!ok) {
          return false
        }
      }
      return true
    },
  },
})
