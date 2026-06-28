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
    ../../modules/editors/neovim
    ../../modules/browsers/qutebrowser
    ../../modules/media/pdf/zathura
    ../../modules/media/img/swayimg
    ../../modules/math/latex
  ];
}

