{ config, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry = {
      package = pkgs.wayprompt;
      program = "pinentry-wayprompt";
    };
    defaultCacheTtl = 3600; #s
    maxCacheTtl = 86400; #s
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass-wayland.withExtensions (exts: with exts; [
      pass-otp
      pass-import
      pass-update
    ]);
    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
      PASSWORD_STORE_CLIP_TIME = "30";
      PASSWORD_STORE_GENERATED_LENGTH = "32";
    };
  };
}
