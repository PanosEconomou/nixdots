{ config, pkgs, ... } :
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  services.displayManager.defaultSession = "hyprland-uwsm";
}

