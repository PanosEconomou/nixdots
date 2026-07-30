{ config, lib, ... }:
let
  cfg = config.pantry.home.math.sagemath;
in
{
  options.pantry.home.math.sagemath = {
    enable = lib.mkEnableOption "enable sagemath";
  };

  config = lib.mkIf cfg.enable {
    programs.sagemath = {
      enable = true;
    };
  };
}
