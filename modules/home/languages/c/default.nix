{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.languages.c;
in
{
  options.pantry.home.languages.c = {
    enable = lib.mkEnableOption "enable c language support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Compilers
      gcc

      # Build
      gnumake
      cmakeCurses
      pkg-config

      # Debug 
      gdb

      # LSP and Format
      clang-tools
      neocmakelsp
      gersemi
      cmake-format
    ];
  };
}
