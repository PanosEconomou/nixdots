{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.qmk;
in
{
  options.pantry.home.utilities.qmk = {
    enable = lib.mkEnableOption "enable qmk";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      qmk
    ];
  };
}
