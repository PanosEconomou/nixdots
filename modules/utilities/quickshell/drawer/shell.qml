import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Shapes

ShellRoot {
  PanelWindow {
    id: win 
    property bool revealed: true
    visible: revealed || progress > 0.001
    color: "transparent"

    anchors {
      top: true
      left: true
      right: true
      bottom: true
    }
    
    // Steal Keyboard focus when revealed
    WlrLayershell.keyboardFocus: revealed ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // Disable focus on click away
    MouseArea {
      anchors.fill: parent
      onClicked: win.revealed = false
    }
    // Animate reveal
    property real progress: revealed ? 1 : 0
    Behavior on progress {
      NumberAnimation {
        duration: win.revealed ? 260 : 190
        easing.type: win.revealed ? Easing.InCubic : Easing.OutCubic
      }
    }

    Shape {
      id: notch
      property real bodyWidth: 600 
      property real notchHeight: win.progress * 300 
      property real topRadius: 38
      property real bottomRadius: 28

      implicitWidth: bodyWidth + 2 * topRadius
      implicitHeight: notchHeight
      preferredRendererType: Shape.CurveRenderer

      anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
      }

      ShapePath {
        fillColor: "#1e1e2e"
        strokeWidth: 0
        PathSvg {
          path: {
            const W = notch.bodyWidth
            const H = notch.notchHeight
            const rt = Math.min(H-notch.bottomRadius, notch.topRadius)
            const rb = notch.bottomRadius
            return `M 0 0
            L ${W + 2*rt} 0
            A ${rt} ${rt} 0 0 0 ${W + rt} ${rt}
            L ${W + rt} ${H - rb}
            A ${rb} ${rb} 0 0 1 ${W + rt - rb} ${H}
            L ${rt + rb} ${H}
            A ${rb} ${rb} 0 0 1 ${rt} ${H - rb}
            L ${rt} ${rt}
            A ${rt} ${rt} 0 0 0 0 0
            Z`
          }
        }
      }
    }
  }
}
