# module template
{ config, lib, ... }:
let
  cfg = config.pantry.home.browsers.firefox;
in
{
  options.pantry.home.browsers.firefox = {
    enable  = lib.mkEnableOption "enable firefox";
    default = lib.mkEnableOption "set default browser";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };

    xdg.mimeApps = lib.mkIf cfg.default {
      enable = true;
      defaultApplications = lib.genAttrs [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ] ( _: [ "firefox.desktop" ]);
    };

  };
}
