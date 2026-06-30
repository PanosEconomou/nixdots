// Read the output of the autogenerate color pallette by matugen
// as derived from the current background

pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  property var c: ({})

  FileView {
    path: Quickshell.env("HOME") + "/.local/state/quickshell/colors.json"
    watchChanges: true
    onFileChanged: reload()
    onLoaded: root.c = JSON.parse(text())
  }
}
