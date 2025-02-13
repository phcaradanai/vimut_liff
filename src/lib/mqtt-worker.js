const sharedWorker = new window.SharedWorker('/js/mqtt-worker.js')

export const mqttWorker = sharedWorker.port
mqttWorker.start()

const mqttLookup = {}

mqttWorker.addEventListener('message', async e => {
  let data = e.data

  if (data.type === 'connect') {
    console.log('mqtt-worker', data.id, 'connected')
  } else if (data.type === 'message') {
    let topic = data.topic
    let payload = data.payload
    let topics = mqttLookup[data.id]?.topics

    // console.log('mqtt', data.id, topic)
    if (!topics?.[topic]?.length) {
      console.log('mqtt', data.id, 'no subscribe for topic', topic)
      return
    }
    let json = payload
    try {
      let jsonText = await byteArrayToText(payload, 'utf-8')
      json = JSON.parse(jsonText)
    } catch (e) {
      console.log('mqtt', data.id, 'payload not a json', payload.toString('utf-8'))
      console.log(e.message)
    }
    for (let cb of topics[topic]) {
      if (typeof cb === 'function') {
        cb(topic, json)
      }
    }
  } else if (data.type === 'disconnect') {
    console.log('mqtt', data.id, 'disconnected')
  } else if (data.type === 'reconnect') {
    console.log('mqtt', data.id, 'reconnecting')
  } else {
    console.log('wsMqtt: unknown data', data)
  }
})

export function MqttClient(id, config) {
  if (mqttLookup[id]) {
    return mqttLookup[id]
  }
  mqttLookup[id] = new MqttClientClass(id, config)
  return mqttLookup[id]
}

export class MqttClientClass {
  constructor(id, config) {
    this.id = id
    this.topics = {}
    let message = JSON.parse(JSON.stringify({
      type: 'connect',
      id,
      ...config,
    }))
    mqttWorker.postMessage(message)
  }

  publish(topic, payload) {
    let message = JSON.parse(JSON.stringify({
      id: this.id,
      type: 'publish',
      topic,
      payload,
    }))
    mqttWorker.postMessage(message)
  }

  subscribe(topic, cb) {
    if (!this.topics[topic]) {
      this.topics[topic] = [cb]
    } else {
      let prev = this.topics[topic].find(x => x === cb)
      if (!prev) {
        this.topics[topic].push(cb)
      }
    }
    let message = JSON.parse(JSON.stringify({
      id: this.id,
      type: 'subscribe',
      topic,
    }))
    mqttWorker.postMessage(message)
  }

  unsubscribe(topic, cb) {
    if (this.topics[topic]?.length) {
      let idx = this.topics[topic].findIndex(x => x === cb)
      if (idx >= 0) {
        this.topics[topic].splice(idx, 1)
      }
    }
    if (!(this.topics[topic]?.length)) {
      let message = JSON.parse(JSON.stringify({
        id: this.id,
        type: 'unsubscribe',
        topic,
      }))
      mqttWorker.postMessage(message)
    }
  }
}

function byteArrayToText(bytes, encoding) {
  return new Promise(resolve => {
    let blob = new Blob([bytes], { type: 'application/octet-stream' })
    let reader = new FileReader()

    reader.onload = event => {
      resolve(event.target.result)
    }

    if (encoding) {
      reader.readAsText(blob, encoding)
    } else {
      reader.readAsText(blob)
    }
  })
}
