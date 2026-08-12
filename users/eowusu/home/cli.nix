{
  darwin,
  lib,
  pkgs,
  ...
}:
let
  uvxZshCompletion = pkgs.runCommand "uvx-zsh-completion" { } ''
    mkdir -p "$out/share/zsh/site-functions"
    ${pkgs.uv}/bin/uvx --generate-shell-completion zsh \
      > "$out/share/zsh/site-functions/_uvx"
  '';
in
{
  home.packages =
    [
      pkgs.chruby
      pkgs.gh
      pkgs.gopls
      pkgs.prek
      pkgs.protobuf
      pkgs.ripgrep
      pkgs.tree
      pkgs.uv
      pkgs.yt-dlp
      pkgs.zsh-completions
      uvxZshCompletion
    ]
    ++ lib.optionals (!darwin) [ pkgs.nodejs ];

  programs.gpg.enable = true;

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Emmanuel Owusu";
      };

      init.defaultBranch = "main";

      merge = {
        conflictStyle = "diff3";
        tool = "meld";
      };

      pull.rebase = false;

      alias = {
        undo = "reset HEAD~1 --soft";
        unstage = "reset HEAD --";
        uncommit = "reset HEAD~1 --soft";
        recommit = "commit --amend --no-edit";
        get = "pull origin";
        push = "push origin HEAD";
        commit = "commit -m";
        add = "add -p";
        log = "log --graph --all --pretty=format:%C(auto)%h %C(cyan)%ar %C(auto)%d %C(magenta)%an %C(auto)%s";
      };
    };
  };

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.lf.enable = true;
}
