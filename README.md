# linux_setup
Scripts and configs for a GNU/Linux system

## Workstation bootstrap

One bootstrap and one mise manifest configure macOS, Ubuntu, and Fedora:

```bash
./workstation-bootstrap.sh
```

Use the work-specific manifest on managed workstations:

```bash
./workstation-bootstrap.sh --work
```

The older `mac-packages.sh`, `ubuntu-dev-bootstrap.sh`, and
`fedora-dev-bootstrap.sh` names remain as compatibility wrappers.

The ownership boundary is deliberate:

- **Native host packages** provide the OS, kernel, GPU drivers, desktop,
  services, shared libraries, compilers, GUI applications, and bootstrap
  utilities. mise's bootstrap package layer selects apt, dnf, or brew entries
  from the same manifest.
- **mise** provides user-scoped runtimes and developer CLIs. Its canonical
  inventory is
  [`mise/workstation.toml`](mise/workstation.toml), which the bootstrap installs
  as `$XDG_CONFIG_HOME/mise/config.toml` (`~/.config/mise/config.toml` by
  default) before running `mise bootstrap`.

Update user tools with `mise outdated` and `mise upgrade`; do not use direct
`npm install -g`, `go install`, `cargo install`, or `pipx install` for tools
listed in the manifest. The bootstrap script backs up a differing existing
mise configuration before replacing it. Portable Zsh fragments under
`dotfiles/config/zsh/` are installed into `$XDG_CONFIG_HOME/zsh/` without
replacing a machine's complete `~/.zshrc`; a small marked block appended to
`~/.zshrc` sources them, so the fragments are active on fresh hosts that never
install this repository's `dotfiles/zshrc`. It also updates mise itself and adds
mise's shims to `~/.zshenv` and `~/.zprofile`, so managed commands retain
precedence in interactive, login, and noninteractive SSH shells. The same PATH
export is prepended to `~/.bash_profile` and `~/.bashrc`, because mise's own
`~/.bash_profile` activation block stops Bash login shells from reading
`~/.profile` and would otherwise leave `mise` itself off PATH.

On the existing Mac, migrate in phases so current Homebrew casks and services
are not taken over prematurely:

```bash
./workstation-bootstrap.sh --only repos,mise-shell-activate,tools
```

After the old `homebrew.mxcl.*` jobs and cask receipts have been migrated, a
plain `./workstation-bootstrap.sh` converges the complete workstation.
`rjyo/moshi/moshi-hook` remains a documented manual macOS exception: its
Homebrew lifecycle metadata is not currently supported by mise's direct
package backend. Blender is managed under mise's `[tools]`. Everything else
the previous `mac-packages.sh` installed has a manifest entry except the retired
`python@3.10` runtime and Gemini CLI.
`steam` stayed a cask.

Python stays on the 3.14 series, allowing patch upgrades while avoiding the
local 3.15 build's missing standard-library extensions. Python 3.10 is no
longer requested by the shared manifest; existing installations can be kept
until older projects and virtual environments have been checked.
Ubuntu also installs `libgraphviz-dev` alongside Graphviz for applications
that compile against its headers.

When changing Python's minor version on an existing machine, rebuild the
configured Python CLI environments before pruning the old interpreter:

```bash
mise install --force pipx:asciinema pipx:glances pipx:httpie pipx:ranger-fm
mise upgrade --global
mise prune --dry-run
mise prune --tools
```

Verify the applications run after rebuilding; selecting a new global Python
does not convert existing virtual environments. Project environments and
Python runtimes bundled with native applications have their own lifecycle.

### Sync an existing mise configuration

Fetch upstream and compare the appropriate manifest with the live config
before bootstrapping. Check Git history for intentional removals so stale
local entries are not accidentally restored. Work-only applications such as
Orca belong in `mise/work.toml`.

```bash
git fetch origin
git diff HEAD origin/master -- mise/ workstation-bootstrap.sh
diff -u mise/workstation.toml "${XDG_CONFIG_HOME:-$HOME/.config}/mise/config.toml"
MISE_GLOBAL_CONFIG_FILE="$PWD/mise/workstation.toml" mise --cd /tmp install --dry-run
```

Use `mise/work.toml` in both comparisons and the preview on work machines. The
preview runs outside the home directory so the live home config is not also
discovered as a project config.
Keep machine-only settings in `~/.config/mise/config.local.toml` (under
`$XDG_CONFIG_HOME` when set); mise loads them alongside the shared config and
the bootstrap leaves that file in place.
Preview with mise directly: `workstation-bootstrap.sh --dry-run` still updates
mise and copies configs and shell fragments before mise sees that flag. Review
and back up local edits before applying the manifest. Removing a tool from the
config does not mean its installed versions should be pruned; keep old versions
until projects have been checked.

There are also some that can work on macOS.

### How to add color to outputs:

With `echo -e` you can use escape characters:

```bash
echo "TEXT COLOR"
echo -e "\e[1;31m RED \e[0m"
echo -e "\e[1;32m GREEN \e[0m"
echo -e "\e[1;33m YELLOW \e[0m"
echo -e "\e[1;34m BLUE \e[0m"
echo -e "\e[1;35m MAGENTA \e[0m"
echo -e "\e[1;36m CYAN \e[0m"
echo ""
echo "BACKGROUND COLOR"
echo -e "\e[1;41m RED \e[0m"
echo -e "\e[1;42m GREEN \e[0m"
echo -e "\e[1;43m YELLOW \e[0m"
echo -e "\e[1;44m BLUE \e[0m"
echo -e "\e[1;45m MAGENTA \e[0m"
echo -e "\e[1;46m CYAN \e[0m"
```
