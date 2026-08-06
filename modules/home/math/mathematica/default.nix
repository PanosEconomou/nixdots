## IMPORTANT! #########################################
# Since Wolfram is enormously picky and they don't
# make their installer available for package
# managers, for this to work one has to go to their
# Webpage and download the wolfram installer script
# Then use 
# nix-store --add-fixed sha256 Mathematica_XX_LINUX.sh
# and build afterwards
#######################################################

{ config, pkgs, lib, ... }:

let
  cfg = config.pantry.home.math.mathematica;
in
{
  options.pantry.home.math.mathematica = {
    enable = lib.mkEnableOption "Mathematica";

    version = lib.mkOption {
      type = lib.types.str;
      default = "15.0.1";
      description = "Mathematica version. Need not be known to nixpkgs.";
    };

    installer = lib.mkOption {
      type = lib.types.str;
      default = "Wolfram_${cfg.version}_LIN.sh";
      defaultText = lib.literalExpression ''"Wolfram_''${version}_LIN.sh"'';
      description = ''
        Exact installer filename. Must match the --name you used when
        adding it to the store, character for character.
      '';
    };

    hash = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      description = ''
        Flat SRI hash of the installer, from `nix hash file --sri`.

        Must be flat, not recursive — if the build fails claiming the
        installer is not in the store despite you having added it, the hash
        was computed with `nix store add-path` (recursive mode).

        The installer is a build input, not a runtime dependency, so
        `nix-collect-garbage` can reclaim it. Consider registering an
        indirect GC root for the store path if you don't want to re-add it.
      '';
    };

    lang = lib.mkOption {
      type = lib.types.str;
      default = "en";
    };

    language = lib.mkOption {
      type = lib.types.str;
      default = "English";
    };

    cudaSupport = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = cfg.hash != "";
      message = ''
        pantry.home.math.mathematica.hash is unset.

        requireFile matches on a flat (non-recursive) hash, so use
        `nix hash file`, not `nix store add-path`:

          nix hash file --sri ${cfg.installer}

        Set the result as pantry.home.math.mathematica.hash, then add the
        installer to the store in flat mode:

          nix-store --add-fixed sha256 ${cfg.installer}
        '';    
      }];

    home.packages = [
      (pkgs.mathematica.override {
        inherit (cfg) cudaSupport;
        versionInfo = {
          inherit (cfg) version lang language hash installer;
        };
      })
    ];
  };
}
