# put this file in /etc/nixos/
# and add 
#   ./gaming.nix
# to /etc/nixos/configuration.nix in `imports`
{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		steam vulkan-headers ntfs3g
	];
}


