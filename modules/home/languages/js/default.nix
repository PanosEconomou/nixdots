{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.languages.js;
in
{
  options.pantry.home.languages.js = {
    enable = lib.mkEnableOption "enable javascript support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ 
      nodejs
    ];
  };
}
