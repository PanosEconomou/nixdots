{ config, lib, ... }:
let
  cfg = config.pantry.home.media.pdf.zathura;
in
{
  options.pantry.home.media.pdf.zathura = {
    enable = lib.mkEnableOption "enable zathura";
  };

  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable  = true;
      options = {
        statusbar-home-tilde      = true;
        statusbar-basename        = true;
        guioptions                = "none";

        highlight-active-color    = "rgba(168, 234, 237,0.3)";
        highlight-color           = "rgba(168, 234, 237,0.3)";

        synctex                   = true;
        synctex-editor-command    = "nvim --headless -c \\\"VimtexInverseSearch %{line}:%{column} '%{input}'\\\"";
      };

      mappings = {
        "<Right>" = "navigate_index expand";
        "<Left>"  = "navigate_index collapse";
        "<Space>" = "feedkeys \":\"";
      };
    };
  };
}
