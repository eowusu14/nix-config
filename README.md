# Emmanuel's macOS Nix configuration

This repository defines the macOS setup for an Apple Silicon Mac using
[nix-darwin](https://github.com/nix-darwin/nix-darwin),
[Home Manager](https://github.com/nix-community/home-manager), Nix packages,
Homebrew, Homebrew Cask, and the Mac App Store CLI.

It is a personal configuration, not a hardware-independent starter template.
Current host-specific values are centralized in the `darwinHosts` map in
`flake.nix`:

| Setting | Value |
| --- | --- |
| Architecture | `aarch64-darwin` (Apple Silicon) |
| nix-darwin configuration | `emmanuel` |
| macOS hostname | `emmanuel` |
| macOS user | `owusu.boateng` |
| Profile directory | `users/eowusu` |
| Expected checkout | Any path | ~/nix
| nixpkgs channel | `nixpkgs-unstable` |
| Home Manager channel | `master` |

## What is managed

The configuration is split by responsibility:

| Layer | Owns |
| --- | --- |
| nix-darwin | macOS defaults, the user and shell, fonts, system packages, Homebrew packages, and `/Applications/Nix Apps` |
| nix-homebrew | The Homebrew installation, unified `brew` launcher, and pinned official taps |
| Home Manager | shell tools, tmux, terminal utilities, session variables, and user dotfiles |
| Nix packages | reproducible CLI tools, fonts, and macOS applications available in nixpkgs |
| Homebrew formulae | tools that are intentionally sourced from Brew, such as `go`, `neovim`, `python3`, and `samba` |
| Homebrew casks | GUI applications such as Ghostty, Obsidian, Slack, VS Code, Zed, and Zoom |
| `mas` | applications installed from the signed-in Mac App Store account |

The system configuration also applies macOS preferences for the Dock, Finder,
login window, keyboard repeat rate, appearance, and trackpad behavior.

## Repository layout

```text
.
|-- flake.nix                       # Inputs and host outputs
|-- flake.lock                      # Exact revisions used by every flake input
|-- Makefile                        # Rebuild and update commands
|-- lib/
|   `-- mksystem.nix                # Shared system + Home Manager wiring
|-- machines/
|   `-- macbook.nix                 # Apple Silicon macOS machine settings
`-- users/eowusu/
    |-- darwin.nix                  # macOS packages, Homebrew, fonts, and defaults
    |-- home-manager.nix            # User programs and dotfile links
    `-- dotfiles/                   # Zsh, Git, tmux, Neovim, Ghostty, Aerospace
```

`lib/mksystem.nix` embeds Home Manager in each Darwin system configuration. The
flake intentionally exposes only integrated Darwin configurations, giving system
and user changes one activation path.

The repository still contains dormant Linux module stubs, but they are not
exported as deployable `nixosConfigurations` until proper hardware modules are
provided.

The Makefile derives `FLAKE_DIR` from its own location and defaults
`DARWIN_HOST` to `emmanuel`. Both can be overridden when invoking Make.

## Prerequisites

Before the first activation, the Mac needs:

1. A Mac matching the selected host's `system` and machine module. The current
   `emmanuel` entry targets Apple Silicon with `aarch64-darwin`.
2. An existing macOS account whose short username matches
   `darwinHosts.<host>.user`.
3. A working Nix or Lix installation with flakes enabled.
4. Xcode Command Line Tools, required by Homebrew.
5. Git, or another way to obtain this repository, checked out at any local path.
6. A signed-in Mac App Store account for the entries in `masApps`.

The `user` value controls the macOS home directory, primary user, Home Manager
target, and Homebrew ownership. The `profile` value selects the configuration
directory under `users/`; it can remain `eowusu` when reusing that profile for a
different username.

Nix installation is deliberately external to nix-darwin because
`users/eowusu/darwin.nix` sets `nix.enable = false`. This is suitable when Nix
is managed by another installer.

## Bootstrap a new Mac

Clone the repository wherever configuration repositories are kept:

```sh
git clone git@github.com:eowusu14/nix-config.git nix-config
cd nix-config
```

For the first activation, run nix-darwin directly from its upstream flake:

```sh
sudo nix run github:nix-darwin/nix-darwin/master#darwin-rebuild -- \
  switch --flake .#emmanuel --show-trace
```

After that activation makes `darwin-rebuild` available, use the Makefile
commands.

The first run can take a while. It installs Homebrew, downloads Nix packages,
installs the formulae and casks declared in `users/eowusu/darwin.nix`, and
invokes `mas`. Existing Home Manager files can be moved aside with the `.backup`
suffix; an existing backup with the same name may need to be handled manually.

## Adding another Mac

Add a host entry to `darwinHosts` in `flake.nix`. The host name becomes the
nix-darwin output name and is passed into `networking.hostName`:

```nix
darwinHosts = {
  emmanuel = {
    machine = "macbook";
    system = "aarch64-darwin";
    user = "owusu.boateng";
    profile = "eowusu";
  };

  "work-mac" = {
    machine = "work-mac";
    system = "aarch64-darwin";
    user = "work-user";
    profile = "work-user";
  };
};
```

Create `machines/work-mac.nix` and the corresponding files under
`users/work-user`, then activate that host with:

```sh
make rebuild DARWIN_HOST=work-mac
```

Integrated Home Manager configurations are generated for every Darwin host
automatically.

## Day-to-day commands

Apply the current configuration without changing flake input revisions:

```sh
make rebuild
```

Update all Nix and Homebrew inputs, then rebuild once:

```sh
make update
```

Use the narrower targets when only one package-management layer should change.
Update the Nix package set, nix-darwin, and Home Manager without changing
Homebrew inputs or upgrading Homebrew packages:

```sh
make update-nix
```

`darwin-rebuild` does **not** update Nix package versions by itself. Nix package
versions come from the `nixpkgs` revision in `flake.lock`; `make update-nix`
advances that revision before rebuilding.

Update the pinned Homebrew implementation and taps, then apply the configuration:

```sh
make update-homebrew
```

All Make targets install missing declared Brew packages but do not imperatively
upgrade existing Brew or App Store packages. Review and commit the resulting
`flake.lock` diff after any update command.

Useful lower-level commands:

```sh
# Build and evaluate without activating the new generation
sudo darwin-rebuild build --flake .#emmanuel --show-trace

# Update only selected flake inputs
nix flake update nixpkgs home-manager nix-darwin --flake .

# Inspect flake outputs and locked inputs
nix flake show .
nix flake metadata .
```

The working tree may show as dirty during evaluation when local changes have not
been committed. That warning is informational. Nix evaluates tracked files from
the current Git tree plus its tracked modifications; newly created files must be
added to Git before a flake can see them reliably.

## Update and rollback model

Nix and Homebrew have different update semantics in this repository:

| Command | Nix packages | Homebrew formulae/casks | macOS settings |
| --- | --- | --- | --- |
| `make rebuild` | Uses versions already pinned in `flake.lock` | Installs missing declarations; does not upgrade existing packages | Reapplied |
| `make update` | Updates all flake inputs | Updates Homebrew/tap pins without upgrading installed packages | Reapplied |
| `make update-nix` | Updates nixpkgs, nix-darwin, and Home Manager | Unchanged | Reapplied |
| `make update-homebrew` | Unchanged | Updates Homebrew/tap pins without upgrading installed packages | Reapplied |

Before a broad update, commit or stash intentional work so the lockfile change is
easy to review or revert. If a new generation is bad, inspect and roll back the
nix-darwin generations:

```sh
darwin-rebuild --list-generations
sudo darwin-rebuild --rollback
```

A rollback restores the previous Nix system generation and its pinned inputs.
The Make targets do not perform non-rollbackable Brew or App Store upgrades.

## Adding or changing software

Choose one owner for each package where practical.

### Nix system package

Add the package to `environment.systemPackages` in
`users/eowusu/darwin.nix`:

```nix
environment.systemPackages = [
  pkgs.ripgrep
];
```

Use this for system-wide tools, fonts, and applications that work well from
nixpkgs.

### Home Manager package or program

Add a package to `home.packages`, or enable its Home Manager module, in
`users/eowusu/home-manager.nix`:

```nix
programs.zoxide = {
  enable = true;
  enableZshIntegration = true;
};
```

Use this for user-scoped CLI tools and programs whose configuration Home Manager
can manage directly.

### Homebrew formula or cask

Add CLI formulae to `homebrew.brews` and GUI applications to
`homebrew.casks` in `users/eowusu/darwin.nix`.

Because `homebrew.onActivation.cleanup = "none"`, removing an item from these
lists does not uninstall it. Remove obsolete packages manually or deliberately
change the cleanup policy after reviewing its effect on packages that are not
declared here.

### Mac App Store application

Add the application name and numeric App Store ID to `homebrew.masApps`. The
current macOS user must already be signed in to the App Store.

### Dotfile

Put source files under `users/eowusu/dotfiles` and declare them in
`users/eowusu/home-manager.nix` with `home.file` or `xdg.configFile`.

All dotfiles use repository-relative Home Manager sources. This keeps the
checkout relocatable and makes the activated configuration reproducible, but
dotfile edits take effect only after `make rebuild`.

### macOS preference

Add supported preferences under `system.defaults` in
`users/eowusu/darwin.nix`. Some settings require logging out or restarting the
affected application before macOS reflects the new value.

Do not casually change `system.stateVersion` or `home.stateVersion`. They record
the compatibility baseline for stateful module behavior, not the desired package
release.
