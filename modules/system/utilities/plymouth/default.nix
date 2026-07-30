{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.system.utilities.plymouth;
in
{
  options.pantry.system.utilities.plymouth = {
    enable = lib.mkEnableOption "plymouth boot splash";

    theme = lib.mkOption {
      type = lib.types.str;
      default = "splash";
      example = "hexagon_dots";
      description = ''
        Theme name from the adi1090x theme pack. The pack is built with only
        this theme selected, so it must be a valid name from that collection.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.systemd.enable = true;

    boot.plymouth = {
      enable = true;
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ cfg.theme ];
        })
      ];
      theme = cfg.theme;
    };

    # Get rid of the linux start text
    boot.kernelParams = [ "quiet" "splash" ];
    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;
  };
}
