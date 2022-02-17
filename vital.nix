# put this file in /etc/nixos/
# and add 
#   ./vital.nix
# to /etc/nixos/configuration.nix in `imports`
{pkgs, config, ... }:

{
	environment.systemPackages = with pkgs; [
		git wget gnumake curl htop wireshark docker docker-compose konsole google-chrome firefox teams discord slack spectacle qpaeq envsubst python plasma-integration plasma-browser-integration kdeplasma-addons bluedevil yakuake vscode amarok ];
	nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
}


