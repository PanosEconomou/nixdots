{ pkgs, config, ... }:
let
  repo = "${config.home.homeDirectory}/.nixos/modules/utilities/matugen";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  home.packages = [ pkgs.matugen ];

  # SYmlink config files
  xdg.configFile."matugen" = {
    source = link "config";
    recursive = true;
  };
}
