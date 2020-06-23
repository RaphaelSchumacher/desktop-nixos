# put this file in /etc/nixos/
# and add 
#   ./network.nix
# to /etc/nixos/configuration.nix in `imports`
{ config, pkgs, ... }:

{
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.macvtap0 = {
    name = "macvtap0";
    virtual = true;
    virtualType = "tap";
  };
  networking.bridges.br0.interfaces = [ "enp0s31f6" "macvtap0" ];
  networking.interfaces.br0.useDHCP = true;
  networking.firewall.extraCommands = ''
	  iptables -A FORWARD -i br0 -o enp0s31f6 -m state --state RELATED,ESTABLISHED -j ACCEPT  	
  '';
}
