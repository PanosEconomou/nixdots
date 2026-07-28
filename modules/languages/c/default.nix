{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Compilers
    gcc

    # Build
    gnumake
    cmakeCurses
    pkg-config

    # Debug 
    gdb

    # LSP and Format
    clang-tools
    neocmakelsp
    gersemi
    cmake-format
  ];
}

