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
    defaultApplications = 
    let qb = [ "org.qutebrowser.qutebrowser.desktop" ];
    in 
    {
      "text/html" = qb;
      "x-scheme-handler/http" = qb;
      "x-scheme-handler/https" = qb;
      "x-scheme-handler/about" = qb;
      "x-scheme-handler/unknown" = qb;
    };
  };

# Symlink the config files
  xdg.configFile."qutebrowser/theme.py".source          = link "theme.py";
  xdg.configFile."qutebrowser/themes".source            = link "themes";
  xdg.configFile."qutebrowser/autoconfig.yml".source    = link "autoconfig.yml";
  xdg.configFile."qutebrowser/bookmarks".source         = link "bookmarks";
  xdg.configFile."qutebrowser/quickmarks".source        = link "quickmarks";
}

