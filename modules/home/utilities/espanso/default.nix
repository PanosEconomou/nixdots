{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.espanso;
  repo = "${configDir}/modules/home/utilities/espanso/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.home.utilities.espanso = {
    enable = lib.mkEnableOption "enable espanso snippet manager";
  };

  config = lib.mkIf cfg.enable {
    services.espanso = {
      enable          = true;
      waylandSupport  = true;
      package-wayland = pkgs.espanso-wayland;
      x11Support      = false;
    };
  };
}
