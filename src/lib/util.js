import * as _dayjs from 'dayjs'

export const dayjs = _dayjs

export function genLookup(list, key) {
  let out = {}
  for (let item of list) {
    out[item[key]] = item
  }
  return out
}

export async function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms))
}

export function arrayToPack(arr) {
  if (!arr.length) {
    return null
  }
  let keys = Object.keys(arr[0])
  let out = {
    c: keys,
    d: [],
  }
  for (let row of arr) {
    let r = []
    for (let key of keys) {
      r.push(row[key] ?? null)
    }
    out.d.push(r)
  }
  return out
}

export function packToArray(pack) {
  if (!pack || !pack.c || !pack.d) {
    return []
  }
  let out = []
  let numKey = pack.c.length
  for (let r of pack.d) {
    let row = {}
    for (let c = 0; c < numKey; c++) {
      row[pack.c[c]] = r[c] ?? null
    }
    out.push(row)
  }
  return out
}

export function flattenObj(obj) {
  const res = {}
  if (!obj) {
    return
  }
  _flattenObj(obj)
  return res

  function _flattenObj(obj, keyPrefix) {
    for (const key of Object.keys(obj)) {
      const value = obj[key]
      if (typeof value === 'undefined') {
        continue
      }
      const newKey = (keyPrefix ? `${keyPrefix}.${key}` : key)
      if (value && typeof value === 'object') {
        _flattenObj(value, newKey)
        continue
      }
      res[newKey] = value
    }
  }
}

export function unflattenObj(obj) {
  const res = {}
  for (let i in obj) {
    let keys = i.split('.')
    keys.reduce(function (r, e, j) {
      return r[e] || (r[e] = isNaN(Number(keys[j + 1]))
        ? (keys.length - 1 === j ? obj[i] : {})
        : [])
    }, res)
  }
  return res
}
