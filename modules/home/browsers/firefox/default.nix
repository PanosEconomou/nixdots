# module template
{ config, lib, ... }:
let
  cfg = config.pantry.home.browsers.firefox;
in
{
  options.pantry.home.browsers.firefox = {
    enable = lib.mkEnableOption "enable firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };
  };
}
