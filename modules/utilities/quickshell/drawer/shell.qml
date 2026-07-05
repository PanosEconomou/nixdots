pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "modules"

ShellRoot {
  PanelWindow {
    id: root
    property bool shown: false
    anchors { 
      top: true
      left: true
      right: true
      bottom: true 
    }
    visible:                      rectangle.width > 0 || rectangle.height > 0
    color:                        "transparent"
    WlrLayershell.layer:          WlrLayer.Overlay
    WlrLayershell.namespace:      "quickshell:drawer"
    WlrLayershell.keyboardFocus:  shown ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    exclusionMode:                ExclusionMode.Ignore

    IpcHandler {
      target: "drawer"
      function toggle(): void {
        root.shown = !root.shown;
      }
    }
    
    // Cleartext and highlight the text bar when shown is toggled
    onShownChanged: {
      if (shown) {
        search.forceActiveFocus();
      } else {
        search.text = "";
      }
    }

    // Scores applications with fuzzy score
    function fuzzyScore(query, target) {
      query   = query.toLowerCase();
      target  = target.toLowerCase();
      let qi = 0, score = 0, consequtive = 0;
      for (let i=0; i < target.length && qi < query.length; i++ ) {
        if (target[i] === query[qi]) {
          consequtive ++;
          score += 1 + consequtive;
          qi++
        } else {
          consequtive = 0;
        }
      }
      return qi === query.length ? score : -1;
    }

    // The main drawer
    Rectangle {
      property color base:          Colors.c.background
      property real targetWidth:    800
      property real targetHeight:   70
      id:                           rectangle 
      anchors.centerIn:             parent
      anchors.verticalCenterOffset: -50
      radius:                       35
      clip:                         true
      color:                        Qt.rgba(base.r, base.g, base.b, 0.80)
      width:                        root.shown ? targetWidth: 0
      height:                       root.shown ? targetHeight : 0

      // Animate width
      Behavior on width {
        NumberAnimation {
          id: widthanim
          duration: 350 
          easing.type: Easing.OutBack
        }
      }

      // Animate Height
      Behavior on height{
        NumberAnimation {
          id: heightanim 
          duration: 200 
          easing.type: Easing.OutBack
        }
      }

      // Two column layout for textArea and list of apps
      Column {
        anchors.fill:     parent
        anchors.margins:  20
        spacing:          12

        TextField {
          id:     search
          width:  parent.width
          font {
            family:     "Fira Code"
            pixelSize:  20
            weight:     500
          }
          color:                Colors.c.foreground
          selectionColor:       Colors.c.primaryContainer
          selectedTextColor:    Colors.c.onPrimaryContainer
          placeholderTextColor: Colors.c.outline
          placeholderText:      "What's up?"

          cursorDelegate: Rectangle {
            visible:  search.cursorVisible
            color:    Colors.c.primary
            width:    search.cursorRectangle.width
          }
          background: Rectangle { 
            color: "transparent" 
          }

          onTextChanged: appList.currentIndex = 0
          Keys.onEscapePressed: root.shown = false
          Keys.onReturnPressed: {
            if (appList.currentItem) {
              app.values[appList.currentIndex].execute()
              root.shown = false
            }
          }
          Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Tab || event.key === Qt.Key_Down) {
              appList.currentIndex = (appList.currentIndex + 1) % appList.count;
              event.accepted = true;
            }
            if (event.key === Qt.Key_Backtab || event.key === Qt.Key_Up) {
              appList.currentIndex = (appList.currentIndex - 1) % appList.count;
              event.accepted = true;
            }
          }
        }

        // Take the text and produce the right number of results
        ScriptModel {
          id: app
          values: {
            const q = search.text.trim();
            const all = [...DesktopEntries.applications.values].filter(e => e.name);

            if (q === "") {
              rectangle.targetHeight = 70; 
              return {}
            }

            const scored = all.map(e => ({ entry: e, score: root.fuzzyScore(q,e.name) })).filter(s => s.score >= 0);
            scored.sort((a,b) => b.score - a.score);
            if (scored.length === 0) {
              rectangle.targetHeight = 70;
            } else {
              rectangle.targetHeight = 70 + 12 + scored.length * 48;
            }
            return scored.map(s => s.entry)
          }
        }

        // Preview the results
        ListView {
          id:       appList
          width:    parent.width
          height:   parent.height - search.height - parent.spacing
          clip:     true
          model:    app
          spacing:  4

          // The actual thing displayed for each result
          delegate: Rectangle {
            id: entry
            required property var modelData
            required property var index
            property bool isCurrent: ListView.isCurrentItem
            property color base: Colors.c.primaryContainer
            width: appList.width
            height: 44
            radius: 22
            color: (isCurrent || hoverArea.containsMouse) ? Qt.rgba(base.r, base.g, base.b, 0.50) : "transparent"

            Behavior on color {
              ColorAnimation {
                duration: 100
              }
            }

            Row {
              anchors.fill: parent
              anchors.margins: 8
              spacing: 10

              IconImage {
                anchors.verticalCenter: parent.verticalCenter
                implicitSize: 28
                source: entry.modelData.icon ? Quickshell.iconPath(entry.modelData.icon) : ""
              }

              Text {
                anchors.verticalCenter: parent.verticalCenter
                text: entry.modelData.name
                color: (entry.isCurrent || hoverArea.containsMouse) ? Colors.c.onPrimaryContainer : Colors.c.foreground
                font {
                  family: "Fira Code"
                  pixelSize: 16
                  weight: 600
                }
              }
            }

            MouseArea {
              id: hoverArea
              anchors.fill: parent
              hoverEnabled: true
              onClicked: {
                entry.modelData.execute();
                root.shown = false;
              }
            }
          }
        }
      }
    }
  }
}
