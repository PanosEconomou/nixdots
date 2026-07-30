{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.languages.python;
in
{
  options.pantry.home.languages.python = {
    enable = lib.mkEnableOption "enable python support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (python3.withPackages (python-pkgs: with python-pkgs; [

        # For building
        build
        twine

        # For quick science
        numpy
        matplotlib

      ]))

      pyright     # LSP
    ];
  };
}
