{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.communication.signal;
in
{
  options.pantry.home.communication.signal = {
    enable = lib.mkEnableOption "enable signal chat";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.signal-desktop ];
  };
}
