{ config, lib, ... }:
let
  cfg = config.pantry.home.media.img.swayimg;
in
{
  options.pantry.home.media.img.swayimg = {
    enable = lib.mkEnableOption "enable swayimg";
  };

  config = lib.mkIf cfg.enable {
    programs.swayimg = {
      enable = true;
    };
  };
}
