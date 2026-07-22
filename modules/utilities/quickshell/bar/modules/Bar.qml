import Quickshell.Io
import QtQuick

Rectangle {
  id: bar
  
  // Define properties that can be edited from the outside
  width:                        40
  radius:                       width/2
  property color base:          Colors.c.background
  color:                        Qt.rgba(base.r, base.g, base.b, 0.80)
  property int percent:         0
  property color fillColor:     Colors.c.primary
  property real restingX:       13
  property real restingHeight:  90
  property real hoverHeight:    110
  property string glyphicon:    "?"
  property color regularColor:  Colors.c.foreground
  property color contrastColor: Colors.c.onSecondary
  property string glyphfamily:  "Fira Code"
  property int glyphweight:     600
  property int pixelsize:       18
  property int textsize:        16
  property string unitsymbol:   "%"
  property string command:      ""
  
  // Set up command execution
  Process { id: launcher }
  function run(cmd) { launcher.command = ["sh", "-c", cmd]; launcher.running = true }
  property var action: () => run(command);

  // Detect Hover
  MouseArea {
    id: hover
    anchors.fill: parent
    hoverEnabled: true
    onPressed: bar.height = bar.hoverHeight * 0.95
    onReleased: bar.height = bar.hoverHeight
    onClicked: bar.action()
  }

  // Hover Animation
  height: hover.containsMouse ? hoverHeight : restingHeight
  Behavior on height {
    NumberAnimation {
      duration: 350
      easing.type: Easing.OutCubic
    }
  }

  // // Shadow
  // RectangularShadow {
  //   anchors.fill: bar
  //   radius: bar.radius
  //   blur: 3
  //   spread: 1
  //   color: Qt.darker(bar.color, 1.6)
  // }

  // Rectangle that fills this
  Rectangle {
    id:fill

    // Place this from the bottom
    anchors.bottom:           parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter

    // Dynamically update the fill based on the percent attribute
    property real fillFraction: Math.max(0, Math.min(bar.percent, 100))/100
    height: 0.5 * bar.width + (bar.height - 0.5 * bar.width) * fillFraction
    width: Math.min(bar.width, height)
    radius: width/2
    color: bar.fillColor

    // Animations
    Behavior on color {
      ColorAnimation {
        duration: 400
      }
    }

    Behavior on fillFraction {
      NumberAnimation {
        duration: 400
        easing.type: Easing.OutCubic
      }
    }
  }

  // Glyph Rendering 
  Item {
    id: glyph
    anchors.fill: parent

    // Properties of the glyph 
    property string content:  hover.containsMouse ? (bar.percent + bar.unitsymbol) : bar.glyphicon
    property int pixelSize:   hover.containsMouse ? bar.textsize : bar.pixelsize
    Behavior on pixelSize { 
      NumberAnimation { 
        duration: 150 
      } 
    }

    // the split line = top edge of the fill, in this item's coordinates
    property real splitY: fill.y

    // copy shown over the EMPTY part (above the fill line)
    Item {
      anchors.top:  parent.top 
      anchors.left: parent.left
      width: parent.width
      height: Math.max(0, glyph.splitY)
      clip: true
      Text {
        width: glyph.width; height: glyph.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: glyph.content
        font.family: bar.glyphfamily
        font.weight: bar.glyphweight 
        font.pixelSize: glyph.pixelSize
        color: bar.regularColor
      }
    }

    // copy shown over the FILLED part (below the fill line)
    Item {
      anchors.left: parent.left
      y: glyph.splitY
      width: parent.width
      height: Math.max(0, parent.height - glyph.splitY)
      clip: true
      Text {
        width: glyph.width; height: glyph.height
        y: -glyph.splitY                  // pull back up so it lines up with the top copy
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: glyph.content
        font.family: bar.glyphfamily
        font.weight: bar.glyphweight 
        font.pixelSize: glyph.pixelSize
        color: bar.contrastColor
      }
    }
  }
}
