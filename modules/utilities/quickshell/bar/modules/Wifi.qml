import Quickshell.Io
import QtQuick

Bar{
  id: wifi
  property string device: "wlan0"
  property int rssi: 0
  property string ssid: ""
  property bool connected: ssid !== "" && rssi < 0
  percent: {
    if (!connected) return 0
    const clamped = Math.max(-90, Math.min(-30, rssi))
    return Math.round((clamped + 90)/60*100)
  }
  glyphicon: "\udb81\udda9"
  unitsymbol: ""

  // Change the fill color based on the state
  fillColor:{
    if (!connected)     return Colors.c.dimmed
    if (percent >= 66)  return Colors.c.primary
    if (percent >= 33)  return Colors.c.secondary
                        return Colors.c.tertiary
  }
  contrastColor: (!connected) ? Colors.c.foreground : Colors.c.onSecondary

  // Find what the network device is called using iwd
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

  // Check signal strength
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

  // Repeat Every second 
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

