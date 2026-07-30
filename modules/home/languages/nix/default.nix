{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.languages.nix;
in
{
  options.pantry.home.languages.nix = {
    enable = lib.mkEnableOption "enable nix support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nixd
    ];
  };
}
