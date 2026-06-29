{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.google-cursor ];

  # Set the gtk cursor to avoid mismatches
  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name=GoogleDot-White
    gtk-cursor-theme-size=20
  '';
}

