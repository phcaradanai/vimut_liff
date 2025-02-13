import Axios from 'axios'

import config from '@/config.js'

const axiosMap = new Map()

export function useAxios(id, params) {
  let axios = axiosMap.get(id)
  if (!axios) {
    axios = Axios.create(params ?? {
      baseURL: config.apiUrl,
      withCredentials: false,
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
    })
    axiosMap.set(id, axios)
  }
  return axios
}

export default useAxios('api')
