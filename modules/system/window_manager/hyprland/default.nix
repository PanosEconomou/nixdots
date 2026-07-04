{ ... } :
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  services.displayManager.defaultSession      = "hyprland-uwsm";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

