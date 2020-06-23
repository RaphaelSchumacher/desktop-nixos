# put this file in /etc/nixos/
# and add 
#   ./x11.nix
# to /etc/nixos/configuration.nix in `imports`
{ config, pkgs, ... }:
{
# Enable the X11 windowing system.
	services.xserver.enable = true;
	services.xserver.layout = "us";
	services.xserver.xkbOptions = "eurosign:e";

# Enable the KDE Desktop Environment.
	services.xserver.displayManager.sddm.enable = true;
	services.xserver.desktopManager.plasma5.enable = true;
# Video drivers
	services.xserver.videoDrivers = [ "intel" ];
	hardware.opengl.driSupport32Bit = true; 
}

