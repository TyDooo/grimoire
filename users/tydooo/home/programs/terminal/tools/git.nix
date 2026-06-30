{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    settings = {
      user.name = "TyDooo";
      user.email = "tydooo" + "@" + "fastmail." + "com";

      alias = {
        st = "status";
      };

      init.defaultBranch = "main";
    };

    ignores = [
      ".direnv"
      "result"
    ];
  };
}
