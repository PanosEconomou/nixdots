{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
  ];
}

