{ pkgs, ... }:
{
  programs.quickshell = {
    enable = true;
  };

  # Load the language server
  home.packages = with pkgs; [ qt6.qtdeclarative ];
}

