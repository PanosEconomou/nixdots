import Quickshell.Services.UPower
import Quickshell.Io
import QtQuick

Rectangle {
  id: battery
  width: 40
  radius: width/2

  property int percent: Math.round(UPower.displayDevice.percentage * 100)
  property bool charging: UPower.displayDevice.state === UPowerDeviceState.Charging
  property bool chargerConnected: !UPower.onBattery

  readonly property color fillColor: {
    if (percent >= 66) return "#9ece6a"
    if (percent >= 33) return "#e0af68"
    return "#7aa2f7"
  }

  readonly property string glyph: {
    if (charging) return "\udb85\udc0b"
    if (percent < 10) return chargerConnected ? "\udb82\udc9c" : "\udb80\udc83"
    if (percent < 15) return chargerConnected ? "\udb82\udc9c" : "\udb80\udc7a"
    if (percent < 25) return chargerConnected ? "\udb80\udc86" : "\udb80\udc7b"
    if (percent < 35) return chargerConnected ? "\udb80\udc87" : "\udb80\udc7c" 
    if (percent < 45) return chargerConnected ? "\udb80\udc88" : "\udb80\udc7d" 
    if (percent < 55) return chargerConnected ? "\udb82\udc9d" : "\udb80\udc7e" 
    if (percent < 65) return chargerConnected ? "\udb80\udc89" : "\udb80\udc7f" 
    if (percent < 75) return chargerConnected ? "\udb82\udc9e" : "\udb80\udc80" 
    if (percent < 85) return chargerConnected ? "\udb80\udc8a" : "\udb80\udc81" 
    if (percent < 95) return chargerConnected ? "\udb80\udc8b" : "\udb80\udc82" 
    return chargerConnected ? "\udb80\udc85" :"\udb80\udc79"
  }

  // Entrance Animation 
  property real restingX: 13
  x: restingX
  NumberAnimation {
    target: battery
    property: "x"
    from: -battery.width
    to: battery.restingX
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
    anchors.bottom:parent.bottom 
    anchors.horizontalCenter: parent.horizontalCenter

    property real fillFraction: Math.min(battery.percent, 100)/100
    Behavior on fillFraction {
      NumberAnimation {
        duration: 400
        easing.type: Easing.OutCubic
      }
    }

    height: 0.5*battery.width + (battery.height - 0.5*battery.width) * fillFraction
    width: Math.min(battery.width, height)
    color: battery.fillColor
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
    text: hover.containsMouse ? (battery.percent + "%") : battery.glyph
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
}
