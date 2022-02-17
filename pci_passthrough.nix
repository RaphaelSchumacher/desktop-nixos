# put this file in /etc/nixos/
# and add 
#   ./pci-passthrough.nix
# to /etc/nixos/configuration.nix in `imports`

{config, pkgs, lib, ... }:

with lib;
let
cfg = config.pciPassthrough;
in
{
###### interface
        options.pciPassthrough = {
                enable = mkEnableOption "PCI Passthrough";

                cpuType = mkOption {
                        description = "One of `intel` or `amd`";
                        default = "intel";
                        type = types.str;
                };
                pciIDs = mkOption {
                        type = types.str;
                        default = "";
                        description = ''
                                PCI IDs to bind to the vfio-pci driver.
                                '';
                };
        };

###### implementation
        config = (mkIf cfg.enable {

                        boot.kernelParams = [ "${cfg.cpuType}_iommu=on" "pcie_acs_override=both" "iommu=pt" "transparent_hugepage=never" ];
                        boot.extraModprobeConfig ="options vfio-pci ids=${cfg.pciIDs}";

                        boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
                        environment.systemPackages = with pkgs; [
                        qemu
                        OVMF
                        pciutils
                        usbutils
                        dmidecode
                        ];
                        });
}
