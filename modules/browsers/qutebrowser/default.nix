{ config, lib, ... }:
let
  repo = "${config.home.homeDirectory}/.nixos/modules/browsers/qutebrowser/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true;
    extraConfig = "config.source('theme.py')";
  };

  # Symlink the config files
  xdg.configFile."qutebrowser/theme.py".source          = link "theme.py";
  xdg.configFile."qutebrowser/themes".source            = link "themes";
  xdg.configFile."qutebrowser/autoconfig.yml".source    = link "autoconfig.yml";
  xdg.configFile."qutebrowser/bookmarks".source         = link "bookmarks";
  xdg.configFile."qutebrowser/quickmarks".source        = link "quickmarks";
}

