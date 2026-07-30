{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.system.utilities.fonts;
in
{
  options.pantry.system.utilities.fonts = {
    enable = lib.mkEnableOption "source fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
    ];
  };
}
