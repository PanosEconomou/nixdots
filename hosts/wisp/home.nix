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
    ../../modules/utilities/matugen
    ../../modules/utilities/cursors/google-dot

    ../../modules/editors/neovim
    ../../modules/editors/typora

    ../../modules/cad/freecad
    ../../modules/cad/kicad

    # ../../modules/browsers/luakit
    ../../modules/browsers/qutebrowser
    ../../modules/browsers/firefox

    ../../modules/communication/slack
    ../../modules/communication/signal

    ../../modules/media/pdf/zathura
    ../../modules/media/img/swayimg

    ../../modules/math/latex
    ../../modules/math/4ti2
    ../../modules/math/gap
    # ../../modules/math/mathematica

    ../../modules/languages/c
    ../../modules/languages/lua
    ../../modules/languages/python
    ../../modules/languages/nix
    ../../modules/languages/web
    ../../modules/languages/nix
    ../../modules/languages/julia
    ../../modules/languages/js
  ];
}

