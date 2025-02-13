export const ACL = {
  VIEW: 1,
  ADD: 2,
  EDIT: 4,
  DEL: 8,
  EXPORT: 16,
  EXTRA1: 32,
  EXTRA2: 64,
  EXTRA3: 128,
}

export function can(acls, rights, logic = 'or') {
  if (typeof rights === 'number') {
    return (acls & rights) !== 0
  }
  for (let r of rights) {
    let ok = can(acls, r, logic === 'or' ? 'and' : 'or')
    if (logic === 'or' && ok) {
      return true
    } else if (logic === 'and' && !ok) {
      return false
    }
  }
  return logic === 'and'
}

export default {
  ACL,
  can,
}

export function filterFnc(profile, onlySysAdmin = false) {
  return (row, idx, rows) => {
    // FOR projects TABLE, ONLY sysAdmin CAN SEE ALL
    if (onlySysAdmin && (profile?.isSysAdmin === 'Y' || row.id === profile?.projectId)) {
      return true
    }
    // IF HAS projectId, ONLY matched profile.projectId
    if (typeof row.projectId !== 'undefined' && row.projectId !== profile?.projectId) {
      return false
    }
    return true
  }
}
