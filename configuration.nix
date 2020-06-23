# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./network.nix
      ./pulse.nix
      ./pci_passthrough.nix
      ./vital.nix
      ./x11.nix
      ./gaming.nix
    ];
  nixpkgs.config.allowUnfree = true;
  pciPassthrough = {
    enable = true;
    pciIDs = "10de:1f06,10de:10f9,10de:1ada,10de:1adb";
  };
  boot.loader.systemd-boot.enable = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  virtualisation.docker.enable = true; 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     zsh vim pciutils 
  ];

  programs.zsh.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tehrafff = {
     isNormalUser = true;
     shell = pkgs.zsh;
     extraGroups = [ "wheel" "docker" "audio" "video" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}

