# put this file in /etc/nixos/
# and add 
#   ./pulse.nix
# to /etc/nixos/configuration.nix in `imports`
{ config, pkgs, ... }:
{
# Enable sound.
	environment.systemPackages = with pkgs; [
		scream-receivers
	];
	sound.enable = true;
	nixpkgs.config.pulseaudio = true;
	hardware.pulseaudio = {
		enable = true;

		tcp = {
			enable = true;
			anonymousClients.allowAll = true;
		};
	};
	hardware.pulseaudio.extraConfig = ''
		load-module module-equalizer-sink
		load-module module-dbus-protocol
		'';
}

