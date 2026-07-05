{ pkgs, ... }:
{
  home.packages = [ pkgs.typora ];

  # Hide the stupid home menu from typora hahaha
  xdg.configFile."Typora/conf/conf.user.json".text = builtins.toJSON {
    autoHideMenuBar = true;
  };
}
