import { onMounted, onBeforeUnmount, reactive } from 'vue'

const screens = {
  xs: 320,
  sm: 640,
  md: 768,
  lg: 1024,
  xl: 1280,
}

const breakpoints = reactive({ w: 0, h: 0, is: 'xs' })

const getBreakpoint = width => {
  if (width >= screens.xl) return 'xl'
  if (width >= screens.lg) return 'lg'
  if (width >= screens.md) return 'md'
  if (width >= screens.sm) return 'sm'
  return 'all'
}

const setBreakpoint = () => {
  breakpoints.w = window.innerWidth
  breakpoints.h = window.innerHeight
  breakpoints.is = getBreakpoint(window.innerWidth)
}

const useBreakpoint = () => {
  onMounted(() => {
    setBreakpoint()
    window.addEventListener('resize', setBreakpoint)
  })

  onBeforeUnmount(() => {
    window.removeEventListener('resize', setBreakpoint)
  })

  return {
    breakpoints,
  }
}

export default useBreakpoint
