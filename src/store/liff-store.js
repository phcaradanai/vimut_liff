import liff from '@line/liff'
import { useAppStore } from '@/store/app-store.js'
import { useJobStore } from '@/store/job-store'

import { defineStore } from 'pinia'
import axios from '@/lib/axios'

export const useLiffStore = defineStore('liff', {
    state() {
        const appStore = useAppStore()
        const jobStore = useJobStore()
        return {
            appStore,
            jobStore,
            liffProfile: {
                pictureUrl: '',
                userId: '',
                statusMessage: '',
                displayName: '',
            },
            liffEnv: {
                os: '',
                language: '',
                version: '',
                accessToken: '',
                isInClient: '',
            },
            liffContext: {
                type: '',
                viewType: '',
                utouId: '',
                roomId: '',
                groupId: '',
            },
            liffFriendship: '',
        }
    },
    actions: {
        async initialLiff() {
            liff.ready
                .then(async () => {
                    if (liff.isLoggedIn()) {
                        await this.getUserProfile()
                        await this.getFriendship()

                        this.getEnvironment()
                        this.getContext()
                    } else {
                        liff.login()
                    }
                })
                .then(async () => {
                    await this.getToken()
                    await this.jobStore.getJob()

                })

            await liff.init({ liffId: import.meta.env.VITE_LIFF_ID })
        },
        async getToken() {
            try {
                let { data } = await axios.post(`/api/liff/login-line-liff`, {
                    lineId: this.liffProfile.userId,
                })
                let token = data?.data?.token
                this.appStore.setToken(token)
            } catch (e) {
                console.log('error', e)
            }
        },
        async getUserProfile() {
            this.liffProfile = await liff.getProfile()
        },
        getEnvironment() {
            this.liffEnv = {
                os: liff.getOS(),
                language: liff.getLanguage(),
                version: liff.getVersion(),
                accessToken: liff.getAccessToken(),
                isInClient: liff.isInClient(),
            }
        },
        getContext() {
            this.liffContext = liff.getContext()
        },
        async getFriendship() {
            const friend = await liff.getFriendship()
            this.liffFriendship = friend.friendFlag
            if (!friend.friendFlag) {
                if (confirm('คุณยังไม่ได้เพิ่ม Bot เป็นเพื่อน จะเพิ่มเลยไหม?')) {
                    window.location = 'https://line.me/R/ti/p/@000lkhzw'
                }
            }
        },
    }
})