#!/bin/bash

# Fuzzy search Git branches in a repo
# Works in normal terminal, tmux, and tmux -CC
# Looks for local and remote branches
function fsb() {
    local pattern=$*
    local branches branch

    # Collect matching branches
    branches=$(git branch --all | awk 'tolower($0) ~ /'"$pattern"'/') || return

    # Interactive fuzzy finder inline
    branch=$(echo "$branches" | fzf --ansi --reverse --tiebreak=index \
        --header "enter to checkout, q to abort" \
        --bind "q:abort")

    # Bail out if nothing selected
    if [ -z "$branch" ]; then
        echo "[$0] No branch matches the provided pattern"
        return 1
    fi

    # Strip decorations, handle remote branches, and checkout
    git checkout "$(echo "$branch" \
        | sed 's/.* //' \
        | sed 's#remotes/[^/]*/##')"
}

fsb "$@"

