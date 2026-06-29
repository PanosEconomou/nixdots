import Quickshell
import QtQuick
import "modules"

PanelWindow {
  id: root

  anchors {
    left: true
    top: true
    bottom: true
  }

  implicitWidth: 60

  // Turn to floating if needed 
  // exclusiveZone: 0

  color: "transparent"

  Column {
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: 0
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
    Wifi {}
    Volume {}
  }
}
