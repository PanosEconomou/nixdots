{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.system.window_manager.hyprland;
in
{
  options.pantry.system.window_manager.hyprland = {
    enable = lib.mkEnableOption "enable base hyprland";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      config."hyprland".default = [ "hyprland" "gtk" ];
      config.common.default = [ "hyprland" ];
    };
    services.displayManager.defaultSession      = "hyprland-uwsm";
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
