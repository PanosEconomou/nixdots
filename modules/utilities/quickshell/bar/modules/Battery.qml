import Quickshell.Services.UPower
import QtQuick

Bar {
  id: battery
  percent: Math.round(UPower.displayDevice.percentage * 100)
  property bool charging: UPower.displayDevice.state === UPowerDeviceState.Charging
  property bool chargerConnected: !UPower.onBattery

  // Change color based on charge
  fillColor: {
    if (percent >= 66)  return "#9ece6a"
    if (percent >= 33)  return "#e0af68"
    return "#7aa2f7"
  }

  glyphicon: {
    if (charging) return "\udb85\udc0b"
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
}
