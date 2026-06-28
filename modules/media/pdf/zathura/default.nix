{ config, ... }:
{
  programs.zathura = {
    enable  = true;
    options = {
      statusbar-home-tilde      = true;
      statusbar-basename        = true;
      guioptions                = "none";

      highlight-active-color    = "rgba(168, 234, 237,0.3)";
      highlight-color           = "rgba(168, 234, 237,0.3)";

      synctex                   = true;
      synctex-editor-command    = "nvim --headless -c \"VimtexInverseSearch %{line}:%{column} '%{input}'\"";
    };

    mappings = {
      "<Right>" = "navigate_index expand";
      "<Left>"  = "navigate_index collapse";
      "<Space>" = "feedkeys \":\"";
    };
  };
}

