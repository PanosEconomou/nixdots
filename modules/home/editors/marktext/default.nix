{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.editors.marktext;
in
{
  options.pantry.home.editors.marktext = {
    enable = lib.mkEnableOption "enable marktext";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.marktext ];
  };
}
