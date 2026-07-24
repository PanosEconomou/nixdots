{ pkgs, config, configDir, ... }:
let
  repo = "${configDir}/modules/utilities/quickshell";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  programs.quickshell = {
    enable = true;
  };

  # Load the language server
  home.packages = with pkgs; [ qt6.qtdeclarative ];

  # Symlink the bar and drawer
  xdg.configFile."quickshell/bar".source    = link "bar";
  xdg.configFile."quickshell/drawer".source = link "drawer";
  xdg.configFile."quickshell/liner".source  = link "liner";
}

