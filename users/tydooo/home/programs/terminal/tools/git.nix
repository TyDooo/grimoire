{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    settings = {
      user.name = "TyDooo";
      user.email = "tydooo@fastmail.com";

      alias = {
        st = "status";
      };

      init.defaultBranch = "main";
    };

    # signing = {
    #   key = "39EB68CAC6016379";
    #   signByDefault = true;
    # };

    ignores = [
      ".direnv"
      "result"
    ];
  };
}
