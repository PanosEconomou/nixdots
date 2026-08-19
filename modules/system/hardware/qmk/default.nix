{ config, lib, ... }:
let
  cfg = config.pantry.system.hardware.qmk;
in
{
  options.pantry.system.hardware.qmk = {
    enable = lib.mkEnableOption "enable qmk";
  };

  config = lib.mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;
  };
}
