{ config, pkgs, ... }:

{
  home.username = "roland";
  home.homeDirectory = "/home/roland";

  # Keep this at the version matching your initial Home Manager setup.
  home.stateVersion = "25.11";

  home.packages = [
    pkgs.diff-so-fancy
  ];

  programs.git = {
    enable = true;

    settings.alias = {
      aa = "!f() { git add $(git rev-parse --show-toplevel) --all; }; f";
      acm = "commit -am";
      amend = "commit --amend";
      br = "branch";
      checkout = "checkout";
      checkout-pr = "!f() { git fetch origin pull/$1/head:pr-$1 && git checkout pr-$1; }; f";
      cm = "commit -m";
      co = "checkout";
      dc = "diff --cached";
      diffcommit = "!f() { git diff $1~ $1; }; f";
      hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
      isRebaseInProcess = "!f() { test -d \"$(git rev-parse --git-path rebase-merge)\" || test -d \"$(git rev-parse --git-path rebase-apply) 2>/dev/null\"; }; f";
      isWorkDirClean = "!f() { if [ -z \"$(git status --porcelain)\" ]; then return 0; fi; return 1; }; f";
      lasttag = "describe --tags";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      loc = "!git diff --stat `git hash-object -t tree /dev/null` | tail -1 | cut -d' ' -f5";
      pr = "pull-request";
      pull = "pull";
      push = "push";
      st = "status -sb";
      status = "status";
      sum = "log --oneline --no-merges";
      unstage = "reset HEAD";
      wip = "!f() { git aa; git cm 'WIP'; }; f";
      escalera = "!f() { git add $(git rev-parse --show-toplevel)/Makefile.VERSIONS && git cm 'Escalera'; }; f";
      diffo = "!f() { git diff -b origin/master; }; f";
    };

    settings = {
      branch.autosetuprebase = "always";
      color.ui = true;
      color.diff.meta = "bold cyan";
      color.grep = {
        filename = "magenta";
        match = "bold red";
        linenumber = "bold blue";
      };
      commit.template = "~/.gitmessage";
      core = {
        excludesfile = "~/.gitignore";
        pager = "diff-so-fancy | less --tabs=4 -RFX";
        editor = "emacs";
      };
      fetch.prune = true;
      grep.linenumber = true;
      merge.ff = "only";
      push.default = "current";
      rebase.autosquash = true;
      github.user = "RCoeurjoly";
      magithub.online = false;
      "magithub.status" = {
        includeStatusHeader = false;
        includePullRequestsSection = false;
        includeIssuesSection = false;
      };
      http.sslVerify = false;
      submodule.recurse = true;
      user = {
        name = "Roland Coeurjoly";
        email = "rolandcoeurjoly@gmail.com";
      };
    };
  };

  # Keep existing commit template/ignore files under version control in this repo.
  home.file.".gitmessage".source = ./legacy-import/git/.gitmessage;
  home.file.".gitignore".source = ./legacy-import/git/.gitignore;

  programs.readline = {
    enable = true;
    bindings = {
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
    variables = {
      "completion-ignore-case" = true;
      "expand-tilde" = true;
      "convert-meta" = false;
      "input-meta" = true;
      "output-meta" = true;
      "show-all-if-ambiguous" = true;
      "visible-stats" = true;
      "page-completions" = true;
      "completion-query-items" = 200;
      "show-all-if-unmodified" = true;
      "echo-control-characters" = false;
      "mark-directories" = true;
      "mark-symlinked-directories" = true;
    };
  };

  programs.home-manager.enable = true;
}
