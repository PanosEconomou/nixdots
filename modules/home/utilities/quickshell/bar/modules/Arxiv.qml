import Quickshell.Io
import QtQuick

Bar {
  id: arxiv
  property string url:        "https://rss.arxiv.org/atom/hep-th"
  property string type:       "(new|cross)"
  property int articleNum:    0
  property int articleNumMax: 100

  command: "xdg-open https://arxiv.org/list/hep-th/new"
  percent: articleNum/articleNumMax
  unitsymbol: ""
  glyphicon: "\uf15c"
  fillColor: {
    if (percent >= 66)  return Colors.c.primary
    if (percent >= 33)  return Colors.c.secondary
                        return Colors.c.tertiary
  }

  Process {
    id: getNum 
    command: ["sh", "-c", `curl -s '${arxiv.url}' | grep -oE 'Announce Type: ${arxiv.type}' | wc -l`]
    stdout: StdioCollector {
      onStreamFinished: {
        arxiv.articleNum  = Math.min(parseInt(text.trim()) || 0, arxiv.articleNumMax)
        arxiv.percent     = parseFloat(arxiv.articleNum)/arxiv.articleNumMax * 100
      }
    }
  }

  Timer {
    interval:         3600000
    running:          true
    repeat:           true
    triggeredOnStart: true
    onTriggered:      getNum.running = true
  }
}
