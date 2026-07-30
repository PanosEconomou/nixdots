{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.communication.slack;
in
{
  options.pantry.home.communication.slack = {
    enable = lib.mkEnableOption "enable slack client";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.slack ];
  };
}
