{ config, lib, pkgs, nixgl, ... }:
{
  nixGL.packages = import nixgl { inherit pkgs; };
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];

  home = {
    packages = with pkgs; [
      gnumake
      imagemagick   # required by the catimg zsh plugin
      #fortune             # required by the hitchhiker zsh plugin
      #cowsay              # required by the hitchhiker zsh plugin
      nmap                # (also) required by the nmap zsh plugin
      #pass-wayland
      #passExtensions.pass-update
      #passExtensions.pass-otp
      p7zip     # optional dependency for yazi
      poppler   # optional dependency for yazi
      resvg     # optional dependency for yazi
      tlrc
      wl-clipboard
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
        {
          # Null plugin, just sets leader keys as workaround for home-manager's
          # neovim module which puts plugin config on top of the init file.
          # Must be on top so it's the first thing written to init.vim
          # NOTE: this might get fixed in a future release (check again)
          plugin = pkgs.stdenv.mkDerivation {
            name = "vim-plugin-set-leader-keys-to-space";
            src = ./nvim/empty;
            installPhase = ''
              cp -r $src $out
              '';
          };
          config = ''
            let g:mapleader = ' '
            let g:maplocalleader = ' '
            '';
        }

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

    yazi = {
      enable = true;

      keymap = {
        mgr.prepend_keymap = [
          { on = [ "n" ]; run = "arrow next"; desc = "Next file"; }
          { on = [ "r" ]; run = "arrow prev"; desc = "Previous file"; }
          { on = [ "s" ]; run = "leave"; desc = "Back to the parent directory"; }
          { on = [ "t" ]; run = "enter"; desc = "Enter the child directory"; }
          { on = [ "N" ]; run = "seek -5"; desc = "Seek up 5 units in the preview"; }
          { on = [ "R" ]; run = "seek 5"; desc = "Seek down 5 units in the preview"; }
          { on = [ "S" ]; run = "back"; desc = "Back to previous directory"; }
          { on = [ "T" ]; run = "forward"; desc = "Forward to next directory"; }

          # replaces "r" for renaming, with some more useful bindings
          { on = [ "a" ]; run = "rename --cursor=before_ext"; desc = "Rename selected file(s)"; }
          { on = [ "A" ]; run = "rename --cursor=end"; desc = "Rename selected file(s) from end"; }
          { on = [ "i" ]; run = "rename --cursor=start"; desc = "Rename selected file(s) from start"; }
          { on = [ "I" ]; run = "rename --empty=stem --cursor=start"; desc = "Rename selected file(s), clearing the name"; }

          # replaces "a" for creating (create [e]mpty file/dir)
          { on = [ "e" ]; run = "create"; desc = "Create a file or directory"; }

          # replaces "s" for searching ([l]ocate)
          { on = [ "l" ]; run = "search --via=fd"; desc = "Search files by name via fd"; }
          { on = [ "L" ]; run = "search --via=rg"; desc = "Search files by content via ripgrep"; }

          # replaces "n/N" for moving between search results
          { on = [ "j" ]; run = "find_arrow"; desc = "Next found"; }
          { on = [ "J" ]; run = "find_arrow --previous"; desc = "Previous found"; }
        ];
      };
    };

    # shell configuration, including zsh
    command-not-found.enable = true;
    pay-respects.enable = true;
    starship.enable = true;
    zoxide = {
      enable = true;
      options = [ "--cmd j" ];
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      syntaxHighlighting.highlighters = [ "main" "brackets" ];

      shellAliases = {
        nix-shell = "nix-shell --command ${pkgs.zsh}/bin/zsh";
        nvd = "neovide";

        g = "git";
        ga = "git add";
        gai = "git add --interactive";
        gap = "git add --patch";
        gc = "git commit";
        gcm = "git commit -m";
        gd = "git diff";
        gds = "git diff --staged";
        gf = "git fetch";
        gfa = "git fetch --all";
        glg = "git lg";
        glga = "git lga";
        gp = "git push";
        gpf = "git push --force";
        gr = "git restore";
        gs = "git status";
        gst = "git status --short --branch";
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
          "gitignore"
          #"hitchhiker"
          "magic-enter"
          "man"
          "nmap"
          #"pass"
          "systemadmin"
          "systemd"
          "tldr"
          "universalarchive"
        ];
      };

      initContent = builtins.readFile(./zsh/init_extra.sh);
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
        merge.tool = "vimdiff";
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
        a = "add";
        ai = "add --interactive";
        ap = "add --patch";
        c = "commit";
        ca = "commit --amend";
        car = "commit --amend --reuse-message=HEAD";
        co = "checkout";
        cob = "checkout -b";
        d = "diff";
        ds = "diff --staged";
        did = "diff --no-ext-diff";
        f = "fetch";
        fa = "fetch --all";
        glog = "log --graph --abbrev-commit --decorate --all --format=format:\"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)\"";
        lg = "log --graph --pretty=format:'%C(bold blue)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative --date-order";
        lga = "log --graph --pretty=format:'%C(bold blue)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative --date-order --all";
        lp = "log --patch";
        p = "push";
        pa = "push --all";
        pf = "push --force";
        rs = "restore";
        rss = "restore --staged";
        rsp = "restore --patch";
        rssp = "restore --staged --patch";
        s = "status";
        st = "status --short --branch";
        stsh = "stash --keep-index";
        staash = "stash --include-untracked";
        staaash = "stash --all";
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
