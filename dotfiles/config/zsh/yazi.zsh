# Open Yazi and change to its last directory when it exits.
# Use `y` for directory navigation; `yazi` leaves the shell directory unchanged.
function y() {
  local tmp cwd yazi_exit=0
  tmp="$(mktemp -t yazi-cwd.XXXXXX)" || return
  command yazi "$@" --cwd-file="$tmp" || yazi_exit=$?
  IFS= read -r -d '' cwd <"$tmp" || true
  if [[ -n "$cwd" && "$cwd" != "$PWD" && -d "$cwd" ]]; then
    builtin cd -- "$cwd"
  fi
  command rm -f -- "$tmp"
  return "$yazi_exit"
}
