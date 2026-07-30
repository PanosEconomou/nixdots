{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.nnn;
in
{
  options.pantry.home.utilities.nnn = {
    enable = lib.mkEnableOption "enable nnn file manager";
  };

  config = lib.mkIf cfg.enable {
    programs.nnn = {
      enable = true;
      enableBashIntegration = true;
      quitcd = true;
      options = {
        a = true;
        d = false;
        e = true;
      };
      plugins = {
        src = "${pkgs.nnn.src}/plugins";
        mappings = {
          f = "finder";
          o = "fzopen";
          p = "preview-tui";
          d = "diffs";
          t = "nmount";
          v = "imgview";
          z = "autojump";
        };
      };

      extraPackages = with pkgs; [
        fzf                 # finder, fzopen
        ffmpegthumbnailer   # preview-tui
        mediainfo
        bat
        eza
        chafa
        nsxiv               # imgview
        delta               # diffs
        udisks              # nmount
        zoxide              # autojump
        tmux
      ];
    };
  };
}
