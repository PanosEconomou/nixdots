{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.pass;
in
{
  options.pantry.home.utilities.pass = {
    enable = lib.mkEnableOption "enable password-store";
  };

  config = lib.mkIf cfg.enable {
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

    home.packages = with pkgs; [
      cryptsetup
      gptfdisk
      e2fsprogs
    ];

    # Customize wayprompt
    programs.wayprompt = {
      enable = true;
      settings = {
        general = {
          font-regular = "FiraCode Nerd Font:size=13";
          font-large = "FiraCode Nerd Font:size=20";
    
          # no borders anywhere
          border = 0;
          button-border = 0;
          pin-square-border = 0;
    
          corner-radius = 16;
          button-inner-padding = 14;
          vertical-padding = 20;
          horizontal-padding = 26;
          pin-square-size = 12;
          pin-square-amount = 24;
        };
        colours = {
          background = "1E1E2EF2";
          text = "CDD6F4";
          error-text = "F38BA8";
          pin-background = "313244";
          pin-square = "89B4FA";
    
          ok-button = "A6E3A1";
          ok-button-text = "1E1E2E";
          not-ok-button = "F9E2AF";
          not-ok-button-text = "1E1E2E";
          cancel-button = "F38BA8";
          cancel-button-text = "1E1E2E";
        };
      };
    };
  };
}
