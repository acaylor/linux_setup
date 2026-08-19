# linux_setup
Scripts and configs for a GNU/Linux system

## Developer bootstraps

The Ubuntu and Fedora bootstraps provision a small system baseline and the
same mise-managed user toolchain:

```bash
./ubuntu-dev-bootstrap.sh  # Ubuntu
./fedora-dev-bootstrap.sh  # Fedora
```

The ownership boundary is deliberate:

- **Distribution packages** provide the OS, kernel, GPU drivers, desktop,
  services, shared libraries, compilers, and bootstrap utilities such as `git`
  and `curl`.
- **mise** provides user-scoped runtimes and developer CLIs. Its canonical
  inventory is
  [`mise/linux-workstation.toml`](mise/linux-workstation.toml), which the
  bootstrap script installs as `~/.config/mise/config.toml` before running
  `mise install`.

Update user tools with `mise outdated` and `mise upgrade`; do not use direct
`npm install -g`, `go install`, `cargo install`, or `pipx install` for tools
listed in the manifest. The bootstrap script backs up a differing existing
mise configuration before replacing it. It also installs the shared Zsh history
configuration from `dotfiles/config/zsh/history.zsh`.

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
