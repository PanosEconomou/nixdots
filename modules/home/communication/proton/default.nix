{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.home.communication.proton;
  repo = "${configDir}/modules/home/communication/proton/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.home.communication.proton = {
    enable = lib.mkEnableOption "enable proton mail client";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.protonmail-desktop ];
  };
}
