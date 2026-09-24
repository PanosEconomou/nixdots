# module template
{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.unzip;
  repo = "${configDir}/modules/home/utilities/unzip/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.home.utilities.unzip = {
    enable = lib.mkEnableOption "enable unzip";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
     unzip 
    ];
  };
}
