{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.math.latex;
in
{
  options.pantry.home.math.latex = {
    enable = lib.mkEnableOption "enable latex support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      texlive.combined.scheme-full
      neovim-remote                   # For inverse search in Zathura
      texlab
    ];
  };
}
