{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.math._4ti2;
in
{
  options.pantry.home.math._4ti2 = {
    enable = lib.mkEnableOption "enable 4ti2 support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs._4ti2];
  };
}
