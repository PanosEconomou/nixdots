{ pkgs, ... }:
let
  username = "pano";
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {

      # Background
      Background          = "/var/lib/sddm-wallpaper/current.png";
      CropBackground      = "true";
      DimBackground       = "0.0";

      # Blur
      FullBlur            = "false";
      PartialBlur         = "true";

      # Form
      FormPosition        = "center";
      HaveFormBackground  = "true";
      RoundCornders       = "50";

      # Typography
      Font                = "Fira Code";
      # FontSize            = "10";
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
  environment.systemPackages = [ sddm-astronaut pkgs.imagemagick];

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = [ sddm-astronaut ];
    };

    autoLogin = {
      enable = false;
      user = username;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/sddm-wallpaper 0755 ${username} users -"
  ];
}

