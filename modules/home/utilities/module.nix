# module template
{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.CATEGORY.MODULE;
  repo = "${configDir}/modules/CATEGORY/MODULE/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.CATEGORY.MODULE = {
    enable = lib.mkEnableOption "enable MODULE";
  };

  config = lib.mkIf cfg.enable {
    # CONFIG HERE
  };
}
