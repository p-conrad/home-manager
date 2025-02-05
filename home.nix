{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      gnumake
    ];

    username = "peter";
    homeDirectory = "/var/home/peter";

    stateVersion = "24.05";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestions.enable = true;

    };

    git = {
      enable = true;
      userName = "Peter Conrad";
      userEmail = "p.conrad@proton.me";
      signing.key = "6AA3710873E3F85E5C00D5F58801DDE8A5AF9238";
      difftastic.enable = true;

      extraConfig = {
        "difftool \"difftastic\"" = {
          cmd = "${pkgs.difftastic}/bin/difft \"$MERGED\" \"$LOCAL\" \"abcdef1\" \"100644\" \"$REMOTE\" \"abcdef2\" \"100644\"";
        };
        difftool.prompt = false;
        pager.difftool = true;
        diff.tool = "difftastic";
      };

      aliases = {
        lg = "log --graph --pretty=format:'%C(bold blue)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative --date-order";
        lga = "log --graph --pretty=format:'%C(bold blue)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative --date-order --all";
        glog = "log --graph --abbrev-commit --decorate --all --format=format:\"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)\"";
        s = "status";
        st = "status --short --branch";
        stsh = "stash --keep-index";
        staash = "stash --include-untracked";
        staaash = "stash --all";
        d = "diff";
        ds = "diff --staged";
        did = "diff --no-ext-diff";
        c = "commit";
        ca = "commit --amend";
        cr = "commit --reuse-message=ORIG_HEAD";
        f = "fetch";
        fa = "fetch --all";
        p = "push";
        pa = "push --all";
        a = "add";
        ap = "add -p";
        rs = "restore";
        rsp = "restore -p";
      };

      ignores = [
        "*~"
        "*.sw[pon]"
        "*.log"
        "*.tmp"
        ".DS_Store"
        ".env"
        "node_modules/"
        "__pycache__/"
        "*.py[cod]"
      ];
    };
  };
}
