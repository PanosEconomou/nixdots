{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.system.hardware.bluetooth;
in
{
  options.pantry.system.hardware.bluetooth = {
    enable = lib.mkEnableOption "enable bluetooth support";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    # services.blueman.enable = true;
    environment.systemPackages = with pkgs; [ overskride ];
  };
}
