{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (python3.withPackages (python-pkgs: with python-pkgs; [

      # For building
      build
      twine

      # For quick science
      numpy
      matplotlib

    ]))

    pyright     # LSP
  ];
}

