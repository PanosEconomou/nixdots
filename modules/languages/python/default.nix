{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pyright     # Language server for lsp
  ];
}

