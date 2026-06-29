{ pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system.nix
    ];

  # Allow closed source packages
  nixpkgs.config.allowUnfree = true;

  # Home manager setup
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.pano = import ./home.nix;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure network connections 
  networking.hostName = "wisp"; 
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    General.EnableNetworkConfiguration = true;
    Network.EnableIPv6 = true;
    Settings.AutoConnect = true;
  };

  # Set time zone.
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pano = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "tour";
    packages = with pkgs; [
      tree
    ];
  };

  # Use Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
  ];

  system.stateVersion = "26.05"; # Please don't touch :>
}

