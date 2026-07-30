{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.editors.typora;
in
{
  options.pantry.home.editors.typora = {
    enable = lib.mkEnableOption "enable typora";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.typora ];

    # Hide the stupid home menu from typora hahaha
    xdg.configFile."Typora/conf/conf.user.json".text = builtins.toJSON {
      autoHideMenuBar = true;
    };
  };
}
