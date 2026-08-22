# linux_setup
Scripts and configs for a GNU/Linux system

## Workstation bootstrap

One bootstrap and one mise manifest configure macOS, Ubuntu, and Fedora:

```bash
./workstation-bootstrap.sh
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
Blender and `rjyo/moshi/moshi-hook` remain documented manual macOS exceptions:
their Homebrew lifecycle metadata is not currently supported by mise's direct
package backend. Everything else the previous `mac-packages.sh` installed has a
manifest entry; three moved backends rather than disappearing: `gemini-cli`
became `npm:@google/gemini-cli`, `python@3.10` became a second mise Python
version, and `steam` stayed a cask.

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
