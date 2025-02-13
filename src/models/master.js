import { useMasterStore } from '../store/master-store'
const masterStore = useMasterStore()

const SHORT_DOW = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']

export const xentemp = {
  cols: {
    code: {
      text: 'CODE',
      width: '120px',
    },
    displayName: {
      text: 'Name',
    },
    'info.temp': {
      text: 'Temperature',
      width: '80px',
    },
    'info.humi': {
      text: 'Humidity',
      width: '80px',
    },
    'info.lastSeen': {
      text: 'Last Seen',
      width: '120px',
    },
    actions: {
      text: 'Actions',
      width: '120px',
    },
  },

  rowsDisplay(rows) {
    return rows
  },

  inputs: {
    general: [
      { id: 'code', type: 'text', text: 'Code', required: true },
      { id: 'displayName', type: 'text', text: 'Name', required: true },
      { id: 'detail', type: 'textarea', text: 'Detail' },
    ],
    config: [
      {
        id: 'config.adjTemp',
        type: 'number',
        text: 'adj Temp',
        step: 0.01,
      },
      {
        id: 'config.adjHumi',
        type: 'number',
        text: 'adj Humi',
        step: 0.01,
      },
      {
        id: 'config.battStart',
        type: 'date',
        text: 'Batt Start',
      },
      {
        id: 'config.tempProfileId',
        type: 'select',
        text: 'tempProfileId',
        list() {
          let list = masterStore.tempProfiles.map((li) => {
            return {
              value: li.id,
              text: `${li.displayName}`,
            }
          })
          return [{ text: 'Select a Temp Profile' }, ...list]
        },
      },
      {
        id: 'config.notiProfileId',
        type: 'select',
        text: 'notiProfileId',
        list() {
          let list = masterStore.notiProfiles.map((li) => {
            return {
              value: li.id,
              text: `${li.displayName}`,
            }
          })
          return [{ text: 'Select a Noti Profile' }, ...list]
        },
      },
      {
        id: 'config.keeper',
        type: 'select',
        text: 'Keeper',
        list() {
          let list = masterStore.operators.map((li) => {
            return {
              value: li.id,
              text: `${li.displayName}`,
            }
          })
          return [{ text: 'Select an Operator' }, ...list]
        },
      },
    ],
  },
  summary: ['isActive'],
}

export const receptors = {
  cols: {
    code: {
      text: 'CODE',
      width: '120px',
    },
    displayName: {
      text: 'Name',
    },
    'info.lastSeen': {
      text: 'Last Seen',
      width: '120px',
    },
    actions: {
      text: 'Actions',
      width: '120px',
    },
  },

  inputs: {
    general: [
      { id: 'code', type: 'text', text: 'Code', required: true },
      { id: 'displayName', type: 'text', text: 'Name', required: true },
      { id: 'detail', type: 'textarea', text: 'Detail' },
      {
        id: 'config.notiProfileId',
        type: 'select',
        text: 'notiProfileId',
        list() {
          let list = masterStore.notiProfiles.map((li) => {
            return {
              value: li.id,
              text: `${li.displayName}`,
            }
          })
          return [{ text: 'Select a Noti Profile' }, ...list]
        },
      },
    ],
  },
}

export const tempProfiles = {
  cols: {
    code: {
      text: 'CODE',
      width: '120px',
    },
    displayName: {
      text: 'Name',
    },
    actions: {
      text: 'Actions',
      width: '120px',
    },
  },
  inputs: {
    general: [
      { id: 'code', type: 'text', text: 'Code', required: true },
      { id: 'displayName', type: 'text', text: 'Name', required: true },
      { id: 'detail', type: 'textarea', text: 'Detail' },
    ],
    config: [
      {
        id: 'config.tempMin',
        type: 'number',
        text: 'TEMP MIN',
      },
      {
        id: 'config.tempMax',
        type: 'number',
        text: 'TEMP MAX',
      },
      {
        id: 'config.tempHighHard',
        type: 'number',
        text: 'TEMP HIGH HARD',
      },
      {
        id: 'config.tempHighSoft',
        type: 'number',
        text: 'TEMP HIGH SOFT',
      },
      {
        id: 'config.tempLowHard',
        type: 'number',
        text: 'TEMP LOW HARD',
      },
      {
        id: 'config.tempLowSoft',
        type: 'number',
        text: 'TEMP LOW SOFT',
      },
      {
        id: 'config.humiHigh',
        type: 'number',
        text: 'HUMI HIGH',
      },
      {
        id: 'config.humiLow',
        type: 'number',
        text: 'HUMI LOW',
      },
    ],
  },
}

export const setNotiProfileAlarms = (alarmItem) => {

}

export const setNotiProfileInputs = (entity = { config: [] }) => {
  Object.keys(notiProfiles.inputs).forEach(li => {
    if (li !== 'general') {
      delete notiProfiles.inputs[li]
    }
  })
  if (!entity.config?.length) {
    entity.config = [{ name: 'New Profile', operators: [] }]
  } else {
    entity.config[entity?.config?.length ?? 0] = { name: 'New Profile', operators: [] }
  }
  entity?.config?.forEach((e, key) => {
    notiProfiles.inputs[!e.name?.length ? `UNNAMED ${key}` : e.name] = [
      {
        id: `config.${key}.name`,
        text: 'Name',
      },
      {
        id: `config.${key}.type`,
        text: 'Type',
        type: 'select',
        list() {
          let sets = ['TEMP_HIGH', 'TEMP_LOW', 'HUMI_HIGH', 'HUMI_LOW', 'OFFLINE']
          return sets.map(i => ({ value: i, text: i }))
        },
      },
      {
        id: `config.${key}.active`,
        text: 'active',
        type: 'select',
        list() {
          return [
            { value: 0, text: 'OFF' },
            { value: 1, text: 'ON' },
          ]
        },
      },
      {
        id: `config.${key}.operators`,
        root: 'config',
        key: 'operators',
        index: key,
        text: 'operators',
        type: 'select-multi',
        selected: masterStore.operators.filter(li => e.operators?.includes(li.id)),
        data: masterStore.operators.filter(li => !e.operators?.includes(li.id)),
      },
      {
        id: `config.${key}.alarms`,
        text: 'Alarm Method',
        type: 'alarms',
        alarms: {
          type: ['LINE', 'email', 'sms', 'ivr'],
        },
      },
    ]
  })
}

/*  */
export const notiProfiles = {
  cols: {
    code: {
      text: 'CODE',
      width: '120px',
    },
    displayName: {
      text: 'Name',
    },
    actions: {
      text: 'Actions',
      width: '120px',
    },
  },
  inputs: {
    general: [
      { id: 'code', type: 'text', text: 'Code', required: true },
      { id: 'displayName', type: 'text', text: 'Name', required: true },
      { id: 'detail', type: 'textarea', text: 'Detail' },
    ],
    NotifyProfile: [],
    methods() {
      return {
        renderType(key) {
          notiProfiles.inputs.NotifyProfile.push({
            id: `config.${key}.type`,
            text: 'Type',
            type: 'select',
            list() {
              let sets = ['TEMP_HIGH', 'TEMP_LOW', 'HUMI_HIGH', 'HUMI_LOW', 'OFFLINE']
              return sets.map(i => ({ value: i, text: i }))
            },
          })
        },
        generateForm(key) {
          return [
            /* {
              id: `config.${key}.name`,
              text: 'Name',
            }, */
            {
              id: `config.${key}.type`,
              text: 'Type',
              type: 'select',
              list() {
                let sets = ['TEMP_HIGH', 'TEMP_LOW', 'HUMI_HIGH', 'HUMI_LOW', 'OFFLINE']
                return sets.map(i => ({ value: i, text: i }))
              },
            },
            {
              id: `config.${key}.active`,
              text: 'active',
              type: 'radio',
              list() {
                return [
                  { value: 0, text: 'OFF' },
                  { value: 1, text: 'ON' },
                ]
              },
            },
            {
              id: `config.${key}.operators`,
              text: 'operators',
              type: 'checkbox',
              index: key,
              list() {
                return masterStore.operators.map(li => ({
                  text: li.displayName,
                  value: li.id,
                }))
              },
            },
            {
              id: `config.${key}.alarms`,
              text: 'Alarm Method',
              type: 'select',
              list() {
                let sets = ['LINE', 'email', 'sms', 'ivr']
                return sets.map(i => ({ value: i, text: i }))
              },
            },
          ]
        },
      }
    },
    /* [
     {
       type: 'list',
       text: 'Profile',
       list(data) {
         let list = data.map((value, key) => {
           return {
             text: `${value.name ?? 'UNSET'} (${value.type})`,
             value: key,
           }
         })
         return [{ text: 'Select Profile', value: '' }, ...list]
       },
       forms: [
         {
           id: 'name',
           text: 'name',
         },
         {
           id: 'type',
           text: 'type',
         },
         {
           id: 'active',
           text: 'active',
           type: 'select',
           list() {
             return [
               {
                 value: 0,
                 text: 'OFF',
               },
               {
                 value: 1,
                 text: 'ON',
               },
             ]
           },
         },
       ],
     },
   ], */
  },
}

export const operators = {
  cols: {
    code: {
      text: 'CODE',
      width: '120px',
    },
    displayName: {
      text: 'Name',
    },
    actions: {
      text: 'Actions',
      width: '120px',
    },
  },
  inputs: {
    general: [
      { id: 'code', type: 'text', text: 'Code', required: true },
      { id: 'displayName', type: 'text', text: 'Name', required: true },
      { id: 'detail', type: 'textarea', text: 'Detail' },
      {
        id: 'config.notiProfileId',
        type: 'select',
        text: 'notiProfileId',
        list() {
          let list = masterStore.notiProfiles.map((li) => {
            return {
              value: li.id,
              text: `${li.displayName}`,
            }
          })
          return [{ text: 'Select a Noti Profile' }, ...list]
        },
      },
    ],
    NotifyOperator: {
      LINE: [
        {
          id: 'config.LINE.token',
          type: 'text',
          text: 'LINE TOKEN',
        },
        {
          id: 'config.LINE.duty',
          type: 'duty',
          text: 'LINE DUTY',
          forms: SHORT_DOW.map(value => {
            return {
              id: `config.LINE.duty.${value}`,
              text: value,
              input: [
                {
                  id: `config.LINE.duty.${value}.0`,
                  type: 'time',
                  max: `config.LINE.duty.${value}.1`,
                },
                {
                  id: `config.LINE.duty.${value}.1`,
                  type: 'time',
                  min: `config.LINE.duty.${value}.0`,
                },
              ],
            }
          }),
        },
      ],
      EMAIL: [
        {
          id: 'config.email.to',
          type: 'text',
          text: 'EMAIL TO',
        },
        {
          id: 'config.email.cc',
          type: 'text',
          text: 'EMAIL CC',
        },
        {
          id: 'config.email.bcc',
          type: 'text',
          text: 'EMAIL BCC',
        },
        {
          id: 'config.email.duty',
          type: 'duty',
          text: 'EMAIL DUTY',
          forms: SHORT_DOW.map(value => {
            return {
              id: `config.email.duty.${value}`,
              text: value,
              input: [
                {
                  id: `config.email.duty.${value}.0`,
                  type: 'time',
                  // max: `config.email.duty.${value}.1`,
                },
                {
                  id: `config.email.duty.${value}.1`,
                  type: 'time',
                  // min: `config.email.duty.${value}.0`,
                },
              ],
            }
          }),
        },
      ],
    },
  },
}
