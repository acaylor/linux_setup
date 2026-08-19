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
  as `~/.config/mise/config.toml` before running `mise bootstrap`.

Update user tools with `mise outdated` and `mise upgrade`; do not use direct
`npm install -g`, `go install`, `cargo install`, or `pipx install` for tools
listed in the manifest. The bootstrap script backs up a differing existing
mise configuration before replacing it. Portable Zsh fragments under
`dotfiles/config/zsh/` are installed without replacing a machine's complete
`~/.zshrc`. It also updates mise itself and adds mise's shims to `~/.zshenv`,
so managed commands work in both interactive shells and noninteractive SSH
commands.

On the existing Mac, migrate in phases so current Homebrew casks and services
are not taken over prematurely:

```bash
./workstation-bootstrap.sh --only repos,mise-shell-activate,tools
```

After the old `homebrew.mxcl.*` jobs and cask receipts have been migrated, a
plain `./workstation-bootstrap.sh` converges the complete workstation.

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
