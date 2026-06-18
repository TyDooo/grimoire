# NOTE: SOPS is handled by clan internally
{
  config,
  lib,
  ...
}:
let
  # SOPS needs access to the key before the persist dirs are even mounted; so
  # just persisting the key won't work, we must point at /persist
  hasOptinPersistence = config.environment ? persistence."/persist";
in
{
  # Needed for sops-nix to decrypt the host key when using clan
  sops.age.keyFile = "${lib.optionalString hasOptinPersistence "/persist"}/var/lib/sops-nix/key.txt";
}
