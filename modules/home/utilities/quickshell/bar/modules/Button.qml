import Quickshell.Io
import QtQuick

Rectangle {
  id: button

  property string glyph: "?"
  property var action: function() {}
  property color glyphColor: Colors.c.onPrimaryContainer

  width: 34
  height: 34
  radius: width/2
  color: mousearea.containsMouse ? Colors.c.dimmed : Colors.c.primaryContainer

  Text {
    anchors.centerIn: parent
    text: button.glyph
    font.family: "Fira Code"
    font.pixelSize: 18
    color: button.glyphColor
  }

  MouseArea {
    id: mousearea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: button.action()
  }

  property string command: ""
  function run(cmd) { launcher.command = ["sh", "-c", cmd]; launcher.running = true }
  Process { id: launcher }

  Behavior on color {
    ColorAnimation {
      duration: 100
    }
  }
}
