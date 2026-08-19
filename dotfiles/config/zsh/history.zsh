# ---- Persistent, shared Zsh history ----
# Keep this in a user-owned file rather than relying on Bash's HISTCONTROL.
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

# Persist each accepted command immediately and make concurrent terminals share
# one history stream. The duplicate options keep that shared history useful.
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
