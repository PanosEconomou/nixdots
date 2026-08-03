{ ... }:
{
  imports = [ ../../modules/home ];

  home.username = "pano";
  home.homeDirectory = "/home/pano";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  pantry.home = {
    utilities = {
      git.enable                = true;
      kitty.enable              = true;
      shell.enable              = true;
      hyprutils.enable          = true;
      pass.enable               = true;
      nnn.enable                = true;
      quickshell.enable         = true;
      btop.enable               = true;
      wofi.enable               = true;
      matugen.enable            = true;
      cursors.google_dot.enable = true;
      tldrxiv.enable            = true;
      espanso.enable            = false;
    };

    editors = {
      neovim.enable             = true;
      typora.enable             = true;
    };

    cad = {
      freecad.enable            = true;
      kicad.enable              = true;
    };

    browsers = {
      qutebrowser.enable        = true;
      qutebrowser.default       = true;
      luakit.enable             = false;
      firefox.enable            = true;
    };

    communication = {
      slack.enable              = true;
      signal.enable             = true;
      discord.enable            = true;
      proton.enable             = true;
    };

    media = {
      pdf.zathura.enable        = true;
      img.swayimg.enable        = true;
    };

    math = {
      latex.enable              = true;
      _4ti2.enable              = true;
      gap.enable                = true;
      mathematica.enable        = false;
    };

    languages = {
      c.enable                  = true;
      lua.enable                = true;
      python.enable             = true;
      nix.enable                = true;
      web.enable                = true;
      julia.enable              = true;
      js.enable                 = true;
    };
  };
}
