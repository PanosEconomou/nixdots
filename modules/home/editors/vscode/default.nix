{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.home.editors.vscode;
  repo = "${configDir}/modules/home/editors/vscode/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.home.editors.vscode = {
    enable = lib.mkEnableOption "enable vscode";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.vscode ];
  };
}
