{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
    ];

    username = "peter";
    homeDirectory = "/var/home/peter";

    stateVersion = "24.05";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Peter Conrad";
      userEmail = "p.conrad@proton.me";
      signing.key = "6AA3710873E3F85E5C00D5F58801DDE8A5AF9238";

      aliases = {
        lg = "log --graph --pretty=format:'%C(bold blue)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative --date-order";
        lga = "log --graph --pretty=format:'%C(bold blue)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative --date-order --all";
        stsh = "stash --keep-index";
        staash = "stash --include-untracked";
        staaash = "stash --all";
        st = "status --short --branch";
        glog = "log --graph --abbrev-commit --decorate --all --format=format:\"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)\"";
        d = "diff";
        ds = "diff --staged";
        c = "commit";
        f = "fetch";
        fa = "fetch --all";
        p = "push";
        pa = "push --all";
        s = "status";
        ap = "add -p";
        rs = "restore";
        rsp = "restore -p";
      };
    };
  };
}
