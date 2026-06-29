{ ... }:
{
  home.username = "pano";
  home.homeDirectory = "/home/pano";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  imports = [
    ../../modules/utilities/git
    ../../modules/utilities/kitty
    ../../modules/utilities/shell
    ../../modules/utilities/hyprutils
    ../../modules/utilities/nnn
    ../../modules/utilities/quickshell
    ../../modules/utilities/btop
    ../../modules/utilities/wofi

    ../../modules/editors/neovim
    ../../modules/editors/marktext

    ../../modules/browsers/qutebrowser

    ../../modules/media/pdf/zathura
    ../../modules/media/img/swayimg

    ../../modules/math/latex

    ../../modules/languages/c
    ../../modules/languages/lua
    ../../modules/languages/python
    ../../modules/languages/nix
    ../../modules/languages/web
    ../../modules/languages/nix
    ../../modules/languages/julia
  ];
}

