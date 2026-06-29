{
  self,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [ self.inputs.nix-cachyos-kernel.overlays.pinned ];

  boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;

  nix.settings.extra-substituters = [
    "https://attic.xuyh0120.win/lantian"
    "https://cache.xinux.uz"
  ];
  nix.settings.extra-trusted-public-keys = [
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
  ];
}
