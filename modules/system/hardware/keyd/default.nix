{ config, lib, ... }:
let
  cfg = config.pantry.system.hardware.keyd;
in
{
  options.pantry.system.hardware.keyd = {
    enable = lib.mkEnableOption "enable keyd";
  };

  config = lib.mkIf cfg.enable {
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        extraConfig = builtins.readFile ./default.conf;
      };
    }; 
  };
}
