{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.system.hardware.intel_graphics;
in
{
  options.pantry.system.hardware.intel_graphics = {
    enable = lib.mkEnableOption "enable support for intel integrated graphics";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.kernelModules = [ "i915" ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [ 
        intel-media-driver
        vpl-gpu-rt
      ];
    };
  };
}
