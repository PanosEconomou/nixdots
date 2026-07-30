{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.system.utilities.wayland_tools;
in
{
  options.pantry.system.utilities.wayland_tools = {
    enable = lib.mkEnableOption "enable wayland tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wl-clipboard
      grim
      slurp
    ];
  };
}
