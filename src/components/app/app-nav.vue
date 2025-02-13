<template>
  <div class="app-nav" :class="{ 'show': showNav }">
    <div
      ref="menuBg"
      class="bg"
      @click="toggleNav"
    ></div>
    <div class="panel">
      <div class="logo">
        <img :src="`/images/xenex_${theme}.png`" class="h-6">
      </div>
      <div class="top py-2">
        <div class="flex gap-3 items-center h-8">
          <div class="h-8 w-8 rounded-full bg-gray-400 flex-shrink-0"></div>
          <div class="flex-grow flex items-center">
            <ui-select class="flex-grow" v-model="profileId" :items="profileList" @change="onProfileSelect">
            </ui-select>
          </div>
        </div>
      </div>
      <div class="content">
        <ui-list
          :items="menusWithAcl"
          :expanded="expanded"
          @toggle="toggleMenu"
          @item-click="itemClick"
        ></ui-list>
      </div>
      <div class="bottom flex gap-x-6">
        <div class="flex-shrink-0">
          <ui-switch v-model="theme" true-value="light" false-value="dark" icon-true="light_mode" icon-false="dark_mode"></ui-switch>
        </div>
        <div class="flex-shrink-0 flex">
          <ui-select class="flex-grow" v-model="lang" :items="langList"></ui-select>
        </div>
        <div class="flex-grow flex">
          <ui-btn class="flex-grow">
            {{ $t('auth.signout') }}
          </ui-btn>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapWritableState } from 'pinia'
import { useAppStore } from '@/store/app-store'

import { menus } from '@/models/menu'

export default {
  data() {
    const profileList = [
      { id: '', text: 'Admin' },
      { id: 'profile', text: 'Profile' },
    ]
    return {
      appStore: useAppStore(),
      profileId: '',
      profileList,
      langList: [
        { id: 'th', text: 'ไทย' },
        { id: 'en', text: 'Eng' },
      ],
      expanded: {},
      menus,
    }
  },

  computed: {
    ...mapState(useAppStore, ['showNav']),
    ...mapWritableState(useAppStore, ['theme', 'lang']),
    menusWithAcl() {
      return this.filteredMenu(this.menus)
    },
  },

  watch: {
    lang(newValue) {
      this.$i18n.locale = newValue
    },
  },

  methods: {
    toggleNav() {
      this.appStore.toggleNav()
    },

    onProfileSelect(evt) {
      let id = evt.target.value
      setTimeout(() => {
        this.profileId = ''
        if (window.getComputedStyle(this.$refs.menuBg).display !== 'none') {
          this.appStore.toggleNav()
        }
      }, 0)
      if (id === 'profile') {
        this.$router.push('/profile')
      }
    },

    toggleMenu(id) {
      // MULTIPLE TOGGLES
      this.expanded[id] = !this.expanded[id] ? 1 : 0
    },

    itemClick(item) {
      // check if menu blocker is onscreen
      if (window.getComputedStyle(this.$refs.menuBg).display !== 'none') {
        this.appStore.toggleNav()
      }
    },

    filteredMenu(menus) {
      let out = []
      for (let menu of menus) {
        if (menu.acl && !this.$acl.can(menu.acl)) {
          continue
        }
        if (menu.items) {
          let items = this.filteredMenu(menu.items)
          if (!items.length) {
            // skip parent without child
            continue
          }
          out.push({
            ...menu,
            text: this.$t(menu.text),
            items,
          })
        } else {
          out.push({
            ...menu,
            text: this.$t(menu.text),
          })
        }
      }
      return out
    }, // filteredMenu
  }, /// methods
}
</script>

<style>
.app-nav {
  @apply hidden;
  &.show {
    @apply block;
  }
  > .bg {
    @apply absolute top-0 bottom-0 left-0 right-0 bg-dark-500/50;
    @apply md:(hidden);
  }
  > .panel {
    @apply fixed top-0 left-0 right-0 bottom-0 flex flex-col absolute top-0 bottom-0 w-80 bg-gray-100 shadow-md shadow-dark-500/50;
    @apply md:(top-12);
    @apply dark:(bg-black shadow-light-100/50);
    > .logo {
      @apply h-10 px-3 py-2 flex justify-center;
      @apply md:(hidden);
    }
    > .top {
      @apply flex-shrink-0 h-12 bg-gray-200 leading-10 px-3 py-2;
      @apply dark:(bg-dark-200);
    }
    > .content {
      @apply flex-grow overflow-y-auto;
      @apply dark:(bg-dark-200);
    }
    > .bottom {
      @apply flex-shrink-0 h-12 bg-gray-200 leading-10 px-3 py-2;
      @apply dark:(bg-dark-200);
    }
  }

  .ui-list {
    .exact-active {
      @apply font-bold;
    }
  }
}
</style>
