import { defineStore } from 'pinia'
import axios from '@/lib/axios.js'

export const useJobStore = defineStore('job', {
    state() {
        return {
            jobs: [],
            selectedJob: null,
            paramId: null,
            apiFetch: null
        }
    },
    actions: {
        async getJob(paramData) {
            try {
                let { data } = await axios.get(
                    `/api/porter/jobs?jobId=${paramData.jobId}`
                )
                this.apiFetch = {
                    "api": `/api/porter/jobs?jobId=${paramData.jobId}`,
                    "data": data
                }
                let jobs = data?.data?.jobs ?? []
                if (!jobs?.length) {
                    return
                }
                this.selectedJob = jobs[0]
            } catch (e) {
                console.log('error', e)
            }
        },
    }
})