{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.hyprutils;
  repo = "${configDir}/modules/home/utilities/hyprutils";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";

  # Create the change wallpaper manager as executable
  wallpaper = pkgs.writeShellApplication {
    name = "wallpaper";
    runtimeInputs = with pkgs; [ matugen imagemagick coreutils gnused ];
    text = builtins.readFile ./config/scripts/paper.sh;
  };
in
{
  options.pantry.home.utilities.hyprutils = {
    enable = lib.mkEnableOption "some configuration options and modules for hyprland";
  };

  config = lib.mkIf cfg.enable {
    # Symlink the config in .config/hypr
    xdg.enable = true;
    xdg.configFile."hypr".source = link "config";

    # wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.systemd.enable = true;

    # Enable hyprland modules
    home.packages = with pkgs; [
      hypridle
      hyprpaper
      hyprlock
      hyprsunset
      wallpaper
    ];

    # Symlink some wallpapers
    home.file."Pictures".source = link "pictures";

    # Tell Hyprland to use the integrated Graphics 
    xdg.configFile."uwsm/env".text = "export LIBVA_DRIVER_NAME=iHD";
  };
}
