{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.math.gap;
in
{
  options.pantry.home.math.gap = {
    enable = lib.mkEnableOption "enable gap support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.gap ];
  };
}
