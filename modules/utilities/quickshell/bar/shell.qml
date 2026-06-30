import Quickshell
import Quickshell.Wayland
import QtQuick
import "modules"

PanelWindow {
  id: root
  WlrLayershell.namespace: "quickshell:bar"

  anchors {
    left: true
    top: true
    bottom: true
  }
  implicitWidth: 50
  margins.left: 8
  color: "transparent"

  // Turn to floating if needed 
  // exclusiveZone: 0

  Column {
    id: column
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    transform: Translate {
      id: translation
      x: -root.width
    }

    // Entrance Animation
    NumberAnimation {
      running: true
      target: translation
      property: "x"
      from: -root.width
      to: 0
      duration: 450
      easing.type: Easing.OutBack
    }

    Column {
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.topMargin: 8
      spacing: 20

      Clock {
        Button {
          glyph: "\uf293"
          action: () => run("overskride")
        }
        Button {
          glyph: "\uf011"
          action: () => run("poweroff")
        }
      }
    }

    Column {
      anchors.bottom: parent.bottom
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottomMargin: 8
      spacing: 20

      Volume {}
      Wifi {}
      Battery {}
    }
  }
}
