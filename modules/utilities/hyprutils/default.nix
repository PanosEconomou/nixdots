{ config, pkgs, ... } :
{
  # Symlink the config in .config/hypr
  xdg.enable = true;
  xdg.configFile."hypr" = { 
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/modules/utilities/hyprutils/config";
  };

  # wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.systemd.enable = true;

  # Enable hyprland modules
  # services.hypridle.enable = true;
  # services.hyprpaper.enable = true;
  # programs.hyprlock.enable = true;
  home.packages = with pkgs; [
    hypridle
    hyprpaper
    hyprlock
    hyprsunset
  ];
}

