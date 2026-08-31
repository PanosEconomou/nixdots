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
    services.printing.enable = true;

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    hardware.printers = {
      ensurePrinters = [
        {
          name       = "9th-floor";
          location   = "726 Broadway";
          deviceUri  = "ipp://hpm507-3.physics.nyu.edu/ipp/print";
          model      = "everywhere";
          ppdOptions = {
            PageSize = "Letter";
            Duplex   = "DuplexNoTumble";
          };
        }
      ];  
      ensureDefaultPrinter = "9th-floor";
    };

    systemd.services.ensure-printers = { 
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = { 
        Restart    = "on-failure";
        RestartSec = 30; 
      };
    };
  };
}
