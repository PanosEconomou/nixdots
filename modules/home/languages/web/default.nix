{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.languages.web;
in
{
  options.pantry.home.languages.web = {
    enable = lib.mkEnableOption "enable html/css/etc support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vscode-langservers-extracted
    ];
  };
}
