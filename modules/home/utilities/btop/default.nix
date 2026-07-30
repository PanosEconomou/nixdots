{ config, lib, ... }:
let
  cfg = config.pantry.home.utilities.btop;
in
{
  options.pantry.home.utilities.btop = {
    enable = lib.mkEnableOption "enable btop";
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;
    };
  };
}
