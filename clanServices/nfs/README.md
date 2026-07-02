This module sets up one or more NFS servers and clients. It
automatically adds clan machines to the allowed clients list
for each share.

## Usage

```nix
nfs = {
    module.input = "self";
    module.name = "@grimoire/nfs";

    roles.server.machines.nfs-server.settings.shares = {
        music.source = "/mnt/user/media/music";
        pictures.source = "/home/user/Pictures";
    };
    roles.client.machines.nfs-client.settings.mounts = {
        music = {
            server = "nfs-server";
            share = "music";
            path = "/mnt/user/music";
        };
        pictures = {
            server = "nfs-server";
            share = "pictures";
            path = "/mnt/user/pictures";
        };
    };
};
```