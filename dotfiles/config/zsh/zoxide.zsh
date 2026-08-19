# Guarded like the other optional tooling in dotfiles/zshrc: zoxide arrives with
# `mise bootstrap`, so a fresh host sources this fragment before it exists.
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
