{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.languages.lua;
in
{
  options.pantry.home.languages.lua = {
    enable = lib.mkEnableOption "enable lua support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ 
      lua-language-server
    ];
  };
}
