{ inputs, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence = {
    "/persist" = {
      files = [
        # important state
        "/etc/machine-id"
      ];
      directories = [
        "/var/lib/systemd"
        "/var/lib/nixos"
        "/var/db/sudo"

        # Needed for sops-nix to decrypt the host key when using clan
        "/var/lib/sops-nix"
      ];
    };
  };
  programs.fuse.userAllowOther = true;
}
