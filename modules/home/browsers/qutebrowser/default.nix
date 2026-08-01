{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.home.browsers.qutebrowser;
  repo = "${configDir}/modules/home/browsers/qutebrowser/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.home.browsers.qutebrowser = {
    enable  = lib.mkEnableOption "qutebrowser";
    default = lib.mkEnableOption "set default browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.wofi ];
    programs.qutebrowser = {
      enable = true;
      loadAutoconfig = true;
      extraConfig = 
        "config.source('theme.py')\n"+
        "config.source('look.py')";
    };
    
    xdg.mimeApps = lib.mkIf cfg.default {
      enable = true;
      defaultApplications = lib.genAttrs [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ] ( _: [ "org.qutebrowser.qutebrowser.desktop" ]);
    };

    # Symlink the config files
    xdg.configFile."qutebrowser/theme.py".source          = link "theme.py";
    xdg.configFile."qutebrowser/look.py".source           = link "look.py";
    xdg.configFile."qutebrowser/themes".source            = link "themes";
    xdg.configFile."qutebrowser/autoconfig.yml".source    = link "autoconfig.yml";
    xdg.configFile."qutebrowser/bookmarks".source         = link "bookmarks";
    xdg.configFile."qutebrowser/quickmarks".source        = link "quickmarks";
  };
}
