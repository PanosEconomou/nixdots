{ pkgs, config, configDir, ... }:
let
  repo = "${configDir}/modules/utilities/matugen";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  home.packages = [ pkgs.matugen ];

  # Symlink config files
  xdg.configFile."matugen" = {
    source = link "config";
    recursive = true;
  };
}
