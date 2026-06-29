import Quickshell.Io
import QtQuick

Rectangle {
  id: volume
  width: 40
  radius: width/2

  property int percent: 0
  property bool muted: false

  property color bgColor: "#1a1b26"

  readonly property color fillColor: {
    if (muted) return "#565f89"
    if (percent >= 66) return "#9ece6a"
    if (percent >= 33) return "#e0af68"
    return "#7aa2f7"
  }

  property string sinkName: ""     // raw description of the active sink
  property bool isHeadphones: {
    const s = sinkName.toLowerCase()
    return s.includes("headphone") || s.includes("headset")
    || s.includes("earbud")    || s.includes("earphone")
    || s.includes("airpod")    || s.includes("buds")
  }

  readonly property string glyph: {
    if (muted || percent === 0) return isHeadphones ? "\udb81\udfce" : "\uf026"
    if (isHeadphones) return "\udb80\udecb"
    if (percent < 33) return "\uf027"
    if (percent < 66) return "\uf027"
    return "\uf028"
  }

  // Entrance Animation 
  property real restingX: 13
  x: restingX
  NumberAnimation {
    target: volume
    property: "x"
    from: -volume.width
    to: volume.restingX
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

    property real fillFraction: Math.min(volume.percent, 100) / 100
    Behavior on fillFraction {
      NumberAnimation {
        duration: 400
        easing.type: Easing.OutCubic
      }

    }

    height: 0.5*volume.width + (volume.height-0.5*volume.width) * fillFraction
    width: Math.min(volume.width, height)
    color: volume.fillColor
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
    text: hover.containsMouse ? (volume.muted ? "0%":  volume.percent + "%") : volume.glyph
    font.family: "Fira Code"
    font.pixelSize: hover.containsMouse ? 16 : 18
    font.weight: 600
    color: "#c0caf5"
    Behavior on font.pixelSize { 
      NumberAnimation { 
        duration: 150 
      } 
    }
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
        font.pixelSize: hover.containsMouse ? 16 : 18
        font.weight: 600
        Behavior on font.pixelSize { 
          NumberAnimation { 
            duration: 150 
          } 
        }
      }
    }
  }

  Process {
    id: getvolume
    command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
    stdout: StdioCollector {
      onStreamFinished: {
        // "Volume: 0.35" or "Volume: 0.35 [MUTED]"
        const m = text.match(/Volume:\s*([0-9.]+)/)
        if (m) volume.percent = Math.round(parseFloat(m[1]) * 100)
        volume.muted = text.includes("[MUTED]")
      }
    }
  }

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

  Process {
    id: monitor
    command: ["pw-mon", "-N"]
    running: true

    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        if (line.includes("changed") || line.includes("Props")
        || line.includes("param")) {
          debounce.restart()
        }
      }
    }
  }
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

  Timer {
    id: debounce
    interval: 50
    repeat: false
    onTriggered: {
      getvol.running = true
      getsink.running = true
    }
  }

  // ── Initial read at startup (monitor only fires on *changes*) ──
  Component.onCompleted: getvol.running = true
}
