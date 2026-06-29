{ pkgs, config, ... }:
let
  repo = "${config.home.homeDirectory}/.nixos/modules/utilities/quickshell";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  programs.quickshell = {
    enable = true;
  };

  # Load the language server
  home.packages = with pkgs; [ qt6.qtdeclarative ];

  # Symlink the bar
  xdg.configFile."quickshell/bar".source = link "bar";
}

