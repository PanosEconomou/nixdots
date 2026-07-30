{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.quickshell;
  repo = "${configDir}/modules/home/utilities/quickshell";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.home.utilities.quickshell = {
    enable = lib.mkEnableOption "enable quickshell";
  };

  config = lib.mkIf cfg.enable {
    programs.quickshell = {
      enable = true;
    };

    # Load the language server
    home.packages = with pkgs; [ qt6.qtdeclarative ];

    # Symlink the bar and drawer
    xdg.configFile."quickshell/bar".source    = link "bar";
    xdg.configFile."quickshell/drawer".source = link "drawer";
    xdg.configFile."quickshell/liner".source  = link "liner";
  };
}
