// Read the output of the autogenerate color pallette by matugen
// as derived from the current background

pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  property var c: ({
    "background":         "#101417",
    "dimmed":             "#353a3d",
    "primaryContainer":   "#004c6c",
    "onPrimaryContainer": "#c7e7ff",
    "foreground":         "#dfe3e7",
    "primary":            "#92cdf6",
    "primaryVar":         "#c7e7ff",
    "onPrimary":          "#00344c",
    "secondary":          "#b6c9d8",
    "secondaryVar":       "#d2e5f5",
    "onSecondary":        "#21323e",
    "tertiary":           "#cdc0e9",
    "tertiaryVar":        "#e8ddff",
    "onTertiary":         "#342b4b",
    "error":              "#ffb4ab",
    "onError":            "#690005",
    "surfaceContainer":   "#1c2024",
    "outline":            "#8b9198"
  })

  FileView {
    path: Quickshell.env("HOME") + "/.local/state/quickshell/colors.json"
    watchChanges: true
    onFileChanged: reload()
    onLoaded: root.c = JSON.parse(text())
  }
}
