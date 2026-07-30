{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.cad.kicad;
in
{
  options.pantry.home.cad.kicad = {
    enable = lib.mkEnableOption "enable kicad";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.kicad ];
  };
}
