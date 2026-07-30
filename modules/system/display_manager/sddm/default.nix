{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.system.display_manager.sddm;
  username = "pano";
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {

      # Background
      Background          = "/var/lib/wallpaper/current.png";
      CropBackground      = "true";
      DimBackground       = "0.0";

      # Blur
      FullBlur            = "false";
      PartialBlur         = "true";

      # Form
      FormPosition        = "center";
      HaveFormBackground  = "true";
      RoundCorners        = "50";

      # Typography
      Font                = "Fira Code";
      FontSize            = "10";
      HeaderText          = "welcome to wisp";
      HourFormat          = "HH:mm";

      # Others
      ForceLastUser       = "true";
      PasswordFocus       = "true";
      HideVirtualKeyboard = "false";
    };
  };
in
{
  options.pantry.system.display_manager.sddm = {
    enable = lib.mkEnableOption "enable sddm";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ sddm-astronaut pkgs.imagemagick];

    services.displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
          compositor = "kwin";
        };
        theme = "sddm-astronaut-theme";
        extraPackages = [ sddm-astronaut ];
      };

      autoLogin = {
        enable = false;
        user = username;
      };

      defaultSession = "hyprland-uwsm";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/wallpaper 0755 ${username} users -"
    ];
  };
}
