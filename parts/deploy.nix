{
  inputs,
  self,
  ...
}: {
  flake.deploy = {
    autoRollback = true;
    magicRollback = true;
    nodes = {
      zoltraak = {
        hostname = "10.10.10.200";

        profilesOrder = ["system"];
        profiles.system = {
          sshUser = "tydooo";
          user = "root";
          remoteBuild = false;
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.zoltraak;
          interactiveSudo = true;
        };
      };
    };
  };
}
