{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
  ];
}

