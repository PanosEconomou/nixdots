{ pkgs, ... }:
{
  home.packages = with pkgs; [
    texlive.combined.scheme-full
    neovim-remote                   # For inverse search in Zathura
    texlab
  ];
}

