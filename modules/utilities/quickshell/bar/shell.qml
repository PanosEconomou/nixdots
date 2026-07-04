import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import "modules"

PanelWindow {
  id: root
  WlrLayershell.namespace: "quickshell:bar"
  property bool shown: false

  anchors {
    left: true
    top: true
    bottom: true
  }
  implicitWidth: 50
  margins.left: 8
  color: "transparent"

  mask: Region {
    id: clickRegion
    item: (root.shown || anim.running) ? wrapper : null
  }
  // Turn to floating if not shown
  exclusiveZone: shown ? implicitWidth : 0

  // Handles keybinds for opening and closing
  IpcHandler {
    target: "bar"
    function toggle() {
      root.shown = !root.shown;
    }
  }

  Item {
    id: wrapper
    anchors.fill: parent
    enabled: root.shown

    // Animate the x-position of the entire wrapper
    transform: Translate {
      id: translation
      x: root.shown ? 0 : -root.width

      Behavior on x {
        NumberAnimation {
          id: anim
          duration: 250
          easing.type: Easing.OutBack
          onRunningChanged: clickRegion.changed()
        }
      }
    }

    Loader {
      anchors.fill: parent
      active : root.shown || anim.running

      sourceComponent: Item {
        anchors.fill: parent
        Item {
          id: column
          anchors.fill: parent
          // anchors.horizontalCenter: parent.horizontalCenter
          // anchors.top: parent.top
          // anchors.bottom: parent.bottom


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
    }
  }
}
