import Quickshell.Io
import QtQuick

Rectangle {
  id: wifi
  width: 40
  radius: width/2

  property string device: "wlan0"
  property int rssi: 0
  property string ssid: ""
  property bool connected: ssid !== "" && rssi < 0
  readonly property int quality: {
    if (!connected) return 0
    const clamped = Math.max(-90, Math.min(-30, rssi))
    return Math.round((clamped + 90)/60*100)
  }

  readonly property color fillColor: {
    if (!connected) return "#565f89"
    if (quality >= 66) return "#9ece6a"
    if (quality >= 33) return "#e0af68"
    return "#f7768e"
  }

  // Entrance Animation 
  property real restingX: 13
  x: restingX
  NumberAnimation {
    target: wifi
    property: "x"
    from: -wifi.width
    to: wifi.restingX
    duration: 500
    easing.type: Easing.OutBack
    running: true;
  }

  // Detect Hover
  MouseArea {
    id: hover
    anchors.fill: parent
    hoverEnabled: true
  }

  // Hover Animation
  property real restingHeight: 90
  property real hoverHeight: 110
  height: hover.containsMouse ? hoverHeight : restingHeight

  Behavior on height {
    NumberAnimation {
      duration: 350
      easing.type: Easing.OutCubic
    }
  }

  Rectangle {
    id: fill 
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter

    property real fillFraction: wifi.quality / 100
    Behavior on fillFraction {
      NumberAnimation {
        duration: 400
        easing.type: Easing.OutCubic
      }

    }

    height: 0.5*wifi.width + (wifi.height-0.5*wifi.width) * fillFraction
    width: Math.min(wifi.width, height)
    color: wifi.fillColor
    radius: width

    Behavior on color {
      ColorAnimation {
        duration: 400
      }
    }
  }

  Text {
    id: label
    anchors.centerIn: parent
    text: hover.containsMouse ? (wifi.connected ? wifi.quality : "off") : "󰖩"
    font.family: "Fira Code"
    font.pixelSize: 16
    font.weight: 600
    color: "#c0caf5"
  }

  Item {
    anchors.fill: parent
    clip: true
    // this clip region tracks the fill height from the bottom
    Item {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      height: fill.height
      clip: true
      Text {
        // positioned identically to labelBase, but measured from this
        // clipped item's coordinate space
        x: label.x
        y: label.y - (parent.parent.height - parent.height)
        text: label.text
        color: "#1a1b26"          // dark
        font.family: "Fira Code"
        font.pixelSize: 16
        font.weight: 600
      }
    }
  }

  Process {
    id: finddevice
    command: ["iwctl", "device", "list"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        const clean = text.replace(/\u001b\[[0-9;]*m/g, "")
        for (const line of clean.split("\n")) {
          const m = line.match(/^\s*(\w+)\s+[0-9a-fA-F:]{17}\s+on\s/)
          if (m) { 
            wifi.device = m[1]
            break 
          }
        }
      }
    }
  }

  Process {
    id: checkstation
    command: ["iwctl", "station", wifi.device, "show"]
    stdout: StdioCollector {
      onStreamFinished: {
        let foundSsid = ""
        let foundRssi = 0
        let isConnected = false
        for (const line of text.split("\n")) {
          if (line.includes("State") && line.includes("connected"))
          isConnected = true
          const net = line.match(/Connected network\s+(.+?)\s*$/)
          if (net) foundSsid = net[1].trim()
          const sig = line.match(/(?:^|\s)RSSI\s+(-?\d+)\s*dBm/)
          if (sig) foundRssi = parseInt(sig[1])
        }
        wifi.ssid = isConnected ? foundSsid : ""
        wifi.rssi = isConnected ? foundRssi : 0
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      if (wifi.device !== "") checkstation.running = true;
    }
  }
}
