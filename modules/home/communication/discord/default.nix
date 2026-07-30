# module template
{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.communication.discord;
in
{
  options.pantry.home.communication.discord = {
    enable = lib.mkEnableOption "enable discord client";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.discord-ptb ];
  };
}
