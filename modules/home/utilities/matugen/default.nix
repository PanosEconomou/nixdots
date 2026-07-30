{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.matugen;
  repo = "${configDir}/modules/home/utilities/matugen";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.home.utilities.matugen = {
    enable = lib.mkEnableOption "enable matugen";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.matugen ];

    # Symlink config files
    xdg.configFile."matugen" = {
      source = link "config";
      recursive = true;
    };
  };
}
