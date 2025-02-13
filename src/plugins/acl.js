import { useAclStore } from '@/store/acl-store'
import { ACL } from '@/lib/acl.js'

export const install = ({ app, router }) => {
  let aclStore = useAclStore()
  app.config.globalProperties.$acl = aclStore
  app.config.globalProperties.ACL = ACL
}
