importScripts('/js/mqtt.min.js')

const allPorts = []
let mqttLookup = {}

self.onconnect = e => {
  console.log('new connect')
  const port = e.ports[0]
  allPorts.push(port)
  port.addEventListener('message', processMessage)
  port.start()
}

function postToAll(message) {
  for (let i = allPorts.length - 1; i >= 0; i--) {
    const port = allPorts[i]
    try {
      port.postMessage(message)
    } catch (e) {
      console.log('post error, remove port')
      allPorts.splice(i, 1)
    }
  }
}

function processMessage(e) {
  let data = e.data

  let mqttId = data.id || 'default'
  let mqttClient = mqttLookup[mqttId]

  if (data.type === 'connect') {
    if (!mqttClient) {
      mqttClient = self.mqtt.connect(data.url, data.options)
      mqttLookup[mqttId] = mqttClient

      mqttClient.on('connect', () => {
        console.log('mqtt ready', mqttId)
        postToAll({
          id: mqttId,
          type: 'connect',
        })
      })

      mqttClient.on('message', (topic, payload) => {
        console.log('wsMqtt', topic, payload)
        postToAll({
          id: mqttId,
          type: 'message',
          topic,
          payload,
        })
      })
    }
  } else if (data.type === 'publish') {
    if (!mqttClient) {
      return
    }
    let payloadType = typeof data.payload
    let payload = payloadType !== 'string' ? JSON.stringify(data.payload) : data.payload
    mqttClient.publish(data.topic, payload)
  } else if (data.type === 'subscribe' && data.topic) {
    console.log('wsMqtt subscribe', mqttId, data.topic)
    mqttClient.subscribe(data.topic)
  } else {
    console.log('wsMqtt', 'unknown type', data)
  }
}
