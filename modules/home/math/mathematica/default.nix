## IMPORTANT! #########################################
# Since Wolfram is enormously picky and they don't
# make their installer available for package
# managers, for this to work one has to go to their
# Webpage and download the wolfram installer script
# in this directory and then rebuild
#######################################################

{ config, pkgs, configDir, lib, ... }:
let
  cfg           = config.pantry.home.math.mathematica;
  hasInstaller  = builtins.pathExists cfg.installer;
  mathematica   = pkgs.mathematica.override {
    source = builtins.path {
      path = cfg.installer;
      name = baseNameOf cfg.installer;
    };
  };
in
{
  options.pantry.home.math.mathematica = {
    enable    = lib.mkEnableOption "enable Mathematica";

    installer = lib.mkOption {
      type        = lib.types.path;
      default     = "${configDir}/modules/home/math/mathematica/Wolfram_15_LIN.sh";
      defaultText = lib.literalExpression
        ''"''${configDir}/modules/home/math/mathematica/Wolfram_15_LIN.sh"'';
      description = "Path to the Wolfram Linux installer script.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.optional hasInstaller mathematica;

    warnings = lib.optional (!hasInstaller) ''
      ------------------------------------------------------------------------------
      Mathematica was not installed: no installer found at
        ${cfg.installer}
      Download the Linux Wolfram_XX_LIN.sh installer, place it there, and rebuild.
      ------------------------------------------------------------------------------
    '';
  };
}
