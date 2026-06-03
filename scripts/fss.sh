#!/bin/bash

# Fuzzy SSH server manager
# Usage: fss [add|edit|list] [alias user@host description...]
# Servers index: ~/dotfiles/scripts/servers.conf
# Connection config: ~/.ssh/config

SERVERS_FILE="${HOME}/dotfiles/scripts/servers.conf"
SSH_CONFIG="${HOME}/.ssh/config"

_fss_connect() {
    if [ ! -f "$SERVERS_FILE" ] || ! grep -q '[^[:space:]#]' "$SERVERS_FILE" 2>/dev/null; then
        echo "[fss] No servers configured. Use 'fss add' to add one."
        return 1
    fi

    local entry server_alias
    entry=$(grep -v '^[[:space:]]*#\|^[[:space:]]*$' "$SERVERS_FILE" \
        | fzf --ansi --reverse \
              --header "enter to connect, q to abort" \
              --bind "q:abort" \
              --preview 'a=$(echo {} | awk "{print \$1}"); grep -A6 "^Host $a" ~/.ssh/config 2>/dev/null || echo "No ~/.ssh/config entry for $a"')
    server_alias=$(echo "$entry" | awk '{print $1}')
    [ -n "$server_alias" ] && ssh "$server_alias"
}

_fss_list() {
    if [ ! -f "$SERVERS_FILE" ]; then
        echo "[fss] No servers configured. Use 'fss add' to add one."
        return 0
    fi
    grep -v '^[[:space:]]*#\|^[[:space:]]*$' "$SERVERS_FILE"
}

_fss_edit() {
    "${EDITOR:-vi}" "$SERVERS_FILE"
}

_fss_add() {
    local server_alias host user port desc userhost

    if [ $# -ge 2 ]; then
        server_alias="$1"
        userhost="$2"
        shift 2
        desc="$*"
        if [[ "$userhost" == *@* ]]; then
            user="${userhost%%@*}"
            host="${userhost##*@}"
        else
            host="$userhost"
            user="$USER"
        fi
        port="22"
    else
        read -rp "Alias (e.g. dev-box): " server_alias
        [ -z "$server_alias" ] && echo "[fss] Alias required." && return 1

        read -rp "Hostname or IP: " host
        [ -z "$host" ] && echo "[fss] Hostname required." && return 1

        read -rp "User [$USER]: " user
        user="${user:-$USER}"

        read -rp "Port [22]: " port
        port="${port:-22}"

        read -rp "Description (optional): " desc
    fi

    # Guard: duplicate alias check
    if awk -v a="$server_alias" '$1 == a {found=1} END {exit !found}' "$SERVERS_FILE" 2>/dev/null; then
        echo "[fss] Error: '${server_alias}' already exists in servers.conf"
        return 1
    fi
    if awk -v a="$server_alias" '/^Host / && $2 == a {found=1} END {exit !found}' "$SSH_CONFIG" 2>/dev/null; then
        echo "[fss] Error: Host '${server_alias}' already exists in ~/.ssh/config"
        return 1
    fi

    # Append to ~/.ssh/config
    {
        printf '\nHost %s\n' "$server_alias"
        printf '  HostName %s\n' "$host"
        printf '  User %s\n' "$user"
        [ "$port" != "22" ] && printf '  Port %s\n' "$port"
    } >> "$SSH_CONFIG"

    # Append to servers.conf
    printf '%-20s %-30s %s\n' "$server_alias" "${user}@${host}" "$desc" >> "$SERVERS_FILE"

    echo "[fss] Added '${server_alias}' (${user}@${host})"

    # Optional key copy
    read -rp "Copy SSH key to ${server_alias} now? (y/N) " yn
    case "$yn" in
        [yY]) ssh-copy-id "$server_alias" ;;
    esac
}

case "${1:-}" in
    add)  shift; _fss_add "$@" ;;
    edit) _fss_edit ;;
    list) _fss_list ;;
    *)    _fss_connect ;;
esac
