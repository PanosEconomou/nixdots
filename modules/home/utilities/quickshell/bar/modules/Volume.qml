import Quickshell.Io
import QtQuick

Bar {
  id:volume

  // Mute on press
  command: "wpctl set-mute @DEFAULT_SINK@ toggle"
  property bool muted: false

  // Different colors depending on state
  fillColor:{
    if (muted)          return Colors.c.dimmed
    if (percent >= 66)  return Colors.c.primary
    if (percent >= 33)  return Colors.c.secondary
                        return Colors.c.tertiary
  }
  contrastColor: muted ? Colors.c.foreground : Colors.c.onSecondary

  // Who is playing and on what
  property string sinkName: ""
  property bool isHeadphones: {
    const s = sinkName.toLowerCase()
    return s.includes("headphone") || s.includes("headset")
    || s.includes("earbud")    || s.includes("earphone")
    || s.includes("airpod")    || s.includes("buds")
  }

  // Change the grlyph based on the output device
  glyphicon: {
    if (muted || percent === 0) return isHeadphones ? "\udb81\udfce" : "\uf026"
    if (isHeadphones)           return "\udb80\udecb"
    if (percent < 33)           return "\uf027"
    if (percent < 66)           return "\uf027"
                                return "\uf028"
  }

  // Get the volume and set the percent property of the bar
  Process {
    id: getvol
    command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
    stdout: StdioCollector {
      onStreamFinished: {
        const m = text.match(/Volume:\s*([0-9.]+)/)
        if (m) volume.percent = Math.round(parseFloat(m[1]) * 100)
        volume.muted = text.includes("[MUTED]")
      }
    }
  }

  // If the volume is updated update the glyph and percent
  Process {
    id: monitor
    command: ["pw-mon", "-N"]
    running: true

    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        if (line.includes("changed") || line.includes("Props")
        || line.includes("param")) {
            getvol.running = true
            getsink.running = true
        }
      }
    }
  }

  // Obtain the output device name
  Process {
    id: getsink
    command: ["wpctl", "inspect", "@DEFAULT_AUDIO_SINK@"]
    stdout: StdioCollector {
      onStreamFinished: {
        // pull the most human-readable identifier we can find
        let name = ""
        const desc = text.match(/node\.description\s*=\s*"([^"]+)"/)
        const nick = text.match(/node\.nick\s*=\s*"([^"]+)"/)
        const nodeName = text.match(/node\.name\s*=\s*"([^"]+)"/)
        // prefer description, fall back to nick, then node.name
        if (desc) name = desc[1]
        else if (nick) name = nick[1]
        else if (nodeName) name = nodeName[1]
        volume.sinkName = name
      }
    }
  }

  // Read the volume at stratup
  Component.onCompleted: getvol.running = true

}
