const mqttClientLookup = {}

export function MqttClient(id, config) {
  if (mqttClientLookup[id]) {
    return mqttClientLookup[id]
  }
  mqttClientLookup[id] = new MqttClientClass(id, config)
  return mqttClientLookup[id]
}

export class MqttClientClass {
  constructor(id, config) {
    this.id = id
    this.topics = {}

    this.mqttClient = window.mqtt.connect(config.url, config.options)

    this.mqttClient.on('connect', () => {
      console.log('mqtt', this.id, 'connected')
    })

    this.mqttClient.on('message', (topic, payload) => {
      // console.log('mqtt', this.id, topic)
      if (!this.topics[topic]?.length) {
        console.log('mqtt', this.id, 'no subscribe for topic', topic)
        return
      }
      let json = payload
      try {
        json = JSON.parse(payload.toString('utf-8'))
      } catch (e) {
        console.log('mqtt', this.id, 'payload not a json')
      }

      for (let cb of this.topics[topic]) {
        if (typeof cb === 'function') {
          cb(topic, json)
        }
      }
    })

    this.mqttClient.on('disconnect', () => {
      console.log('mqtt', this.id, 'disconnected')
    })

    this.mqttClient.on('reconnect', () => {
      console.log('mqtt', this.id, 'reconnecting')
    })
  }

  publish(topic, payload) {
    if (typeof payload === 'string' || payload instanceof Buffer) {
      this.mqttClient.publish(topic, payload)
    } else {
      this.mqttClient.publish(topic, JSON.stringify(payload))
    }
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
    this.mqttClient.subscribe(topic)
  }

  unsubscribe(topic, cb) {
    if (this.topics[topic]?.length) {
      let idx = this.topics[topic].findIndex(x => x === cb)
      if (idx >= 0) {
        this.topics[topic].splice(idx, 1)
      }
    }
    if (!(this.topics[topic]?.length)) {
      this.mqttClient.unsubscribe(topic)
    }
  }
}
