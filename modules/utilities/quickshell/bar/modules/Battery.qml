import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick

Bar {
  id: battery
  percent: Math.round(UPower.displayDevice.percentage * 100)
  property bool charging: UPower.displayDevice.state === UPowerDeviceState.Charging
  property bool chargerConnected: !UPower.onBattery
  property int endThreshold: -1
  property bool powerSaving: endThreshold <= 90
  property string powerSavingSymbol: "\n\udb80\udf2a"

  // Look at the file where the storage cap is set and change that
  FileView {
    id: endThresholdFile
    path: "/sys/class/power_supply/BAT0/charge_control_end_threshold"
    watchChanges: true
    onFileChanged: reload()
    onTextChanged: battery.endThreshold = parseInt(text().trim())
  }

  // Change color based on charge
  fillColor:{
    if (percent >= 75)  return Colors.c.primary
    if (percent >= 55)  return Colors.c.secondary
    if (percent >= 35)  return Colors.c.tertiary
                        return Colors.c.error
  }
  
  property string icon: { 
    if (charging)     return "\udb85\udc0b"
    if (percent < 10) return chargerConnected ? "\udb82\udc9c" : "\udb80\udc83" 
    if (percent < 15) return chargerConnected ? "\udb82\udc9c" : "\udb80\udc7a"
    if (percent < 25) return chargerConnected ? "\udb80\udc86" : "\udb80\udc7b"
    if (percent < 35) return chargerConnected ? "\udb80\udc87" : "\udb80\udc7c" 
    if (percent < 45) return chargerConnected ? "\udb80\udc88" : "\udb80\udc7d" 
    if (percent < 55) return chargerConnected ? "\udb82\udc9d" : "\udb80\udc7e" 
    if (percent < 65) return chargerConnected ? "\udb80\udc89" : "\udb80\udc7f" 
    if (percent < 75) return chargerConnected ? "\udb82\udc9e" : "\udb80\udc80" 
    if (percent < 85) return chargerConnected ? "\udb80\udc8a" : "\udb80\udc81" 
    if (percent < 95) return chargerConnected ? "\udb80\udc8b" : "\udb80\udc82" 
                      return chargerConnected ? "\udb80\udc85" : "\udb80\udc79"
  } 
  glyphicon: icon + (powerSaving ? powerSavingSymbol : "")
}
