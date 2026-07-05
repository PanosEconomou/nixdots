{ pkgs, ... } :
{
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
}

