import { defineStore } from 'pinia'
import axios from '../lib/axios'

export const useJobStore = defineStore('job', {
    state() {
        return {
            jobs: [],
            selectedJob: null,
            paramId: null,

        }
    },
    actions: {
        async getJob() {
            this.apiFetch = {
                axios: await axios,
                url: `/api/porter/jobs?jobId=${this.paramId.jobId}`
            }
            try {
                let { data } = await axios.get(
                    `/api/porter/jobs?jobId=${this.paramId.jobId}`
                )
                this.apiFetch = {
                    "api": `/api/porter/jobs?jobId=${this.paramId.jobId}`,
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