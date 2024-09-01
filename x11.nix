# put this file in /etc/nixos/
# and add 
#   ./x11.nix
# to /etc/nixos/configuration.nix in `imports`
{ config, pkgs, ... }:
{
# Enable the X11 windowing system.
	services.xserver.enable = true;
	services.xserver.xkb.layout = "us";
        services.xserver.xkb.options = "eurosign:e";	

# Enable the KDE Desktop Environment.
        services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;
# Video drivers
	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.opengl.driSupport32Bit = true; 
}

