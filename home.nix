{ config, lib, pkgs, nixgl, ... }:
{
  nixGL.packages = import nixgl { inherit pkgs; };
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];

  home = {
    packages = with pkgs; [
      gnumake
      imagemagick_light   # required by the catimg zsh plugin
      #fortune             # required by the hitchhiker zsh plugin
      #cowsay              # required by the hitchhiker zsh plugin
      nmap                # (also) required by the nmap zsh plugin
      #pass-wayland
      #passExtensions.pass-update
      #passExtensions.pass-otp
      tlrc
    ];

    shell.enableZshIntegration = true;

    username = "peter";
    homeDirectory = "/var/home/peter";

    stateVersion = "24.05";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    neovide = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.neovide;
      settings = {
        fork = true;
        frame = "full";
        idle = true;
        maximized = false;
        no-multigrid = false;
        srgb = false;
        tabs = false;
        theme = "auto";
        title-hidden = true;
        vsync = true;
        wsl = false;

        font = {
          normal = [];
          size = 12;
        };
      };
    };

    neovim = let
      luaPlug = name: config: {
        plugin = name;
        config = "lua << END\n" + builtins.readFile config + "END";
      };
    in {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraLuaConfig = builtins.readFile(./nvim/init.lua);

      extraPackages = with pkgs; [
        fd
        ripgrep
        wl-clipboard
      ];

      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        Rename

        nvim-web-devicons
        {
          plugin = lualine-nvim;
          config = "lua require('lualine').setup()";
        }
        (luaPlug dashboard-nvim ./nvim/dashboard.lua)
        plenary-nvim
        (luaPlug telescope-nvim ./nvim/telescope.lua)
        (luaPlug orgmode ./nvim/orgmode.lua)

        # some more to check out in the future:
        # mini-nvim
        # renamer

        # color schemes
        vim-one
        papercolor-theme
        nvim-solarized-lua
        catppuccin-nvim
      ];
    };

    # generally useful tools
    bat.enable = true;
    eza = {
      enable = true;
      colors = "auto";
      icons = "auto";
    };
    fd.enable = true;
    fzf.enable = true;
    jq.enable = true;
    ripgrep.enable = true;

    # shell configuration, including zsh
    autojump.enable = true;
    command-not-found.enable = true;
    starship.enable = true;
    thefuck.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      syntaxHighlighting.highlighters = [ "main" "brackets" ];

      shellAliases = {
        nix-shell = "nix-shell --command ${pkgs.zsh}/bin/zsh";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [
          "aliases"
          "catimg"
          "colored-man-pages"
          "copybuffer"
          "copyfile"
          "copypath"
          "dircycle"
          "extract"
          "fasd"
          "gitignore"
          #"hitchhiker"
          "magic-enter"
          "man"
          "nmap"
          #"pass"
          "systemadmin"
          "systemd"
          "thefuck"
          "tldr"
          "universalarchive"
        ];
      };

      initExtra = builtins.readFile(./zsh/init_extra.sh);
    };

    git = {
      enable = true;
      userName = "Peter Conrad";
      userEmail = "p.conrad@proton.me";
      signing.key = "6AA3710873E3F85E5C00D5F58801DDE8A5AF9238";
      difftastic.enable = true;

      extraConfig = {
        branch.sort = "-committerdate";
        commit.verbose = true;
        "url \"git@github.com:\"".insteadOf = "https://github.com/";
        "url \"git@git.sr.ht:\"".insteadOf = "sh:";
        "url \"git@git.sr.ht:~p-conrad/\"".insteadOf = "shp:";
        "difftool \"difftastic\"" = {
          cmd = "${pkgs.difftastic}/bin/difft \"$MERGED\" \"$LOCAL\" \"abcdef1\" \"100644\" \"$REMOTE\" \"abcdef2\" \"100644\"";
        };
        diff.algorithm = "histogram";
        diff.tool = "difftastic";
        difftool.prompt = false;
        diff.submodule = "log";
        help.autocorrect = 15;
        merge.conflictstyle = "zdiff3";
        pager.difftool = true;
        push.autoSetupRemote = true;
        push.followtags = true;
        rebase.autosquash = true;
        rebase.autostash = true;
        rerere.enabled = true;
        submodule.recurse = true;
        status.submoduleSummary = true;
        transfer.fsckobjects = true;
        fetch.fsckobjects = true;
        receive.fsckobjects = true;
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
