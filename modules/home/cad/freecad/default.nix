{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.cad.freecad;
in
{
  options.pantry.home.cad.freecad = {
    enable = lib.mkEnableOption "enable freecad";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.freecad ];
  };
}
