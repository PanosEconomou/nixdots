{ config, configDir, ... }:
let
  repo = "${configDir}/modules/browsers/qutebrowser/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true;
    extraConfig = "config.source('theme.py')";
  };
  
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "qutebrowser.desktop";
      "x-scheme-handler/http" = "qutebrowser.desktop";
      "x-scheme-handler/https" = "qutebrowser.desktop";
      "x-scheme-handler/about" = "qutebrowser.desktop";
      "x-scheme-handler/unknown" = "qutebrowser.desktop";
    };
  };

# Symlink the config files
  xdg.configFile."qutebrowser/theme.py".source          = link "theme.py";
  xdg.configFile."qutebrowser/themes".source            = link "themes";
  xdg.configFile."qutebrowser/autoconfig.yml".source    = link "autoconfig.yml";
  xdg.configFile."qutebrowser/bookmarks".source         = link "bookmarks";
  xdg.configFile."qutebrowser/quickmarks".source        = link "quickmarks";
}

