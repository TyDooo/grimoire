# This help
@help:
    just -l -u

# Update machines (multiple hosts can be updated by space separated list)
[group('clan')]
@update +HOST:
    clan machines update {{HOST}}

@check:
  nix flake check
