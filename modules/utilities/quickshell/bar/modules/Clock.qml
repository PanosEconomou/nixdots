import Quickshell
import QtQuick

Rectangle {
  id: bar
  width: 40
  radius: width / 2
  clip: true
  default property alias menuItems: revealColumn.data

  // ── Layout parameters ──
  property real restingHeight: 90
  property real topPadding: 14        // clock's distance from top when expanded
  property real gap: 10               // space between clock and buttons
  property real bottomPadding: 4

  property bool expanded: hover.hovered

  // Entrance
  property real restingX: 13
  x: restingX
  NumberAnimation {
    target: bar; property: "x"
    from: -bar.width; to: bar.restingX
    duration: 500; easing.type: Easing.OutBack
    running: true
  }

  HoverHandler {
    id: hover
  }

  height: expanded
  ? topPadding + clockFace.height + gap + revealColumn.implicitHeight + bottomPadding
  : restingHeight
  Behavior on height { NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }

  // ── The clock: centered when collapsed, near-top when expanded ──
  Column {
    id: clockFace
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 1

    // KEY: collapsed position uses restingHeight (constant), NOT bar.height.
    // So y animates between two fixed values and never chases the height animation.
    y: bar.expanded
    ? bar.topPadding
    : (bar.restingHeight - height) / 2
    Behavior on y { NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }

    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: Qt.formatDateTime(clock.date, "hh")
      font.family: "Fira Code"; font.pixelSize: 16; font.weight: 600
    }
    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: Qt.formatDateTime(clock.date, "mm")
      font.family: "Fira Code"; font.pixelSize: 16; font.weight: 600
    }
  }

  // ── The buttons: anchored below the clock, fading in on expand ──
  Column {
    id: revealColumn
    anchors.top: clockFace.bottom
    anchors.topMargin: bar.gap
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 6

    opacity: bar.expanded ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 200 } }
    // children passed to the bean land here automatically
  }

  SystemClock { id: clock; precision: SystemClock.Minutes }
}
