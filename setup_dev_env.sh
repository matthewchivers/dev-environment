#!/bin/bash

echo "Configuring shell profile..."

SHELL_NAME=""

# Work out what shell is being used.
if [ -n "$BASH_VERSION" ]; then
    SHELL_NAME="bash"
elif [ -n "$ZSH_VERSION" ]; then
    SHELL_NAME="zsh"
else
    echo "Shell not supported. Please use Bash or Zsh."
    exit 1
fi

SHELL_FILE="$HOME/.$(echo $SHELL_NAME)rc"

aliases=("k='kubectl'"
         "kgp='kubectl get pods'"
         "kctx='kubectl config current-context'"
         "gs='git status'"
         "gc='git commit'"
         "gp='git push'"
         "gd='git diff'"
         "gco='git checkout'"
         "gcb='git checkout -b'"
         "gcm='git checkout master'"
         "gpl='git pull'"
         "gpr='git pull --rebase'"
         "gprc='git pull --rebase --autostash'"
         "gfp='git fetch --all; git pull'"
         )

for alias in "${aliases[@]}"; do
    if ! grep -Fxq "alias $alias" "$SHELL_FILE"; then
        echo "alias $alias" >> "$SHELL_FILE"
    fi
done

# Source the updated shell profile.
source "$SHELL_FILE"

echo "Development environment setup complete."