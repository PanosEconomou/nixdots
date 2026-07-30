{ config, lib, ... }:
let
  cfg = config.pantry.system.utilities.upower;
in
{
  options.pantry.system.utilities.upower = {
    enable = lib.mkEnableOption "enable upower";
  };

  config = lib.mkIf cfg.enable {
    services.upower = {
      enable = true;
    };
  };
}
