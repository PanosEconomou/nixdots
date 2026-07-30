{ config, lib, ... }:
let
  cfg = config.pantry.system.utilities.qt;
in
{
  options.pantry.system.utilities.qt = {
    enable = lib.mkEnableOption "enable qt";
  };

  config = lib.mkIf cfg.enable {
    qt.enable = true;
  };
}
