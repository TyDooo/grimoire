hostname := `hostname`

# This help
@help:
    just -l -u

# Update machines (multiple hosts can be updated by space separated list)
[group('clan')]
@update +HOST:
    clan machines update {{HOST}}

[group('nix')]
@rebuild operation:
    nixos-rebuild {{operation}} --flake .#{{hostname}} --elevate=sudo

[group('nix')]
@check:
  nix flake check
