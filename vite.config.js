import path from 'path'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import Pages from 'vite-plugin-pages'
import Layouts from 'vite-plugin-vue-layouts'
import ViteComponents from 'unplugin-vue-components/vite'
import WindiCSS from 'vite-plugin-windicss'
import VueI18n from '@intlify/vite-plugin-vue-i18n'
import { viteVConsole } from 'vite-plugin-vconsole';
// import { viteObfuscateFile } from 'vite-plugin-obfuscator'

export default defineConfig({
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },

  server: {
    host: '0.0.0.0',
    port: 3000,
    proxy: {
      '/api': {
        target: 'https://api.xengistic.xenex.io/',
        // target: 'http://localhost:7001',
        changeOrigin: true,
      },
    },
  },

  plugins: [
    vue(),
    Pages(),
    Layouts(),
    WindiCSS(),
    ViteComponents(),
    VueI18n({
      compositionOnly: false,
      include: [path.resolve(__dirname, 'locales/**')],
    }),
    viteVConsole({
      entry: path.resolve(__dirname, './src/main.js'), // or you can use entry: [path.resolve('src/main.ts')]
      enabled: true,
      config: {
        log: {
          maxLogNumber: 1000,
        },
        theme: 'dark'
      }
    })
    // viteObfuscateFile(),
  ],
})
