# Print the path of each Zen profile that an install uses by default.
zen_profiles() {
  local base
  for base in "$HOME/Library/Application Support/zen" "$HOME/.zen" "$HOME/.config/zen"; do
    [ -f "$base/profiles.ini" ] || continue
    sed -n 's/^Default=\(Profiles\/.*\)$/\1/p' "$base/profiles.ini" | sort -u | while read -r rel; do
      [ -d "$base/$rel" ] && echo "$base/$rel"
    done
  done
}
