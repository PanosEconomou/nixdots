{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.languages.julia;
in
{
  options.pantry.home.languages.julia = {
    enable = lib.mkEnableOption "enable julia support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      julia-bin
    ];
  };
}
