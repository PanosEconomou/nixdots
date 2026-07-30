{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.df;
in
{
  options.pantry.home.utilities.df = {
    enable = lib.mkEnableOption "enable dwarf-fortress";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      dwarf-fortress
    ];
  };
}
