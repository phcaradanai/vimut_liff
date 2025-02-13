import i18n from '@/lib/i18n.js'
import { useAppStore } from '@/store/app-store.js'

export const install = ({ app }) => {
  app.use(i18n(useAppStore()))
}
