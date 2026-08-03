# module template
{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.system.hardware.printing;
in
{
  options.pantry.system.hardware.printing = {
    enable = lib.mkEnableOption "enable printing tools";
  };

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };

    hardware.printers = {
      ensurePrinters = [
        {
          name       = "9th-floor";
          location   = "726 Broadway";
          deviceUri  = "ipp://hpm507-3.physics.nyu.edu/ipp";
          model      = "everywhere";
          ppdOptions = {
            PageSize = "Letter";
            Duplex   = "DuplexNoTumble";
          };
        }
      ];  
      ensureDefaultPrinter = "9th-floor";
    };
  };
}
