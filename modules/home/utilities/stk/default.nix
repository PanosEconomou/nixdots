# module template
{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.stk;
  repo = "${configDir}/modules/home/utilities/stk/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.home.utilities.stk = {
    enable = lib.mkEnableOption "enable super tux cart";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.supertuxkart ];
  };
}
