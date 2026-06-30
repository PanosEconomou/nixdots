{ pkgs, ... }:
let
  username = "pano";
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {
      Background = "/var/lib/sddm-wallpaper/current.png";
      CropBackground = true;
      FillBlur = "false";
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

