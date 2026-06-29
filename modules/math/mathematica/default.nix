## IMPORTANT! #########################################
# Since Wolfram is enormously picky and they don't
# make their installer available for package
# managers, for this to work one has to go to their
# Webpage and download the wolfram installer script
# in this directory and then rebuild
#######################################################

{ pkgs, config, lib, ... }:
let
  installer = "${config.home.homeDirectory}/.nixos/modules/math/mathematica/Wolfram_15_LIN.sh";
  hasInstaller = builtins.pathExists installer;
  mathematica = pkgs.mathematica.override {
    source = builtins.path {
      path = installer;
      name = "Wolfram_15_LIN.sh";
    };
  };
in
{
  home.packages = lib.optional hasInstaller mathematica;
  warnings = lib.optional (!hasInstaller) ''

    ------------------------------------------------------------------------------
    Mathematica was not installed: no installer found in modules/math/mathematica.
    Download the Linux Wolfram_XX_LIN.sh installer place it there and rebuild.
    ------------------------------------------------------------------------------
    '';
}
