#!/bin/bash

echo "Configuring shell profile..."

# Detect the shell and set the shell configuration file
SHELL_NAME=$(basename "$SHELL")

case "$SHELL_NAME" in
    bash)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            SHELL_FILE="$HOME/.bash_profile"
        else
            SHELL_FILE="$HOME/.bashrc"
        fi
        ;;
    zsh)
        SHELL_FILE="$HOME/.zshrc"
        ;;
    *)
        echo "Unsupported shell: $SHELL_NAME"
        exit 1
        ;;
esac

echo "Using shell configuration file: $SHELL_FILE"

# Function to add an alias if it doesn't already exist
add_alias() {
    local name="$1"
    local command="$2"
    if ! grep -q "^alias $name=" "$SHELL_FILE"; then
        echo "alias $name='$command'" >> "$SHELL_FILE"
        echo "Added alias: $name"
    else
        echo "Alias $name already exists"
    fi
}

# Define your aliases in an associative array
declare -A aliases=(
    ["k"]="kubectl"
    ["kgp"]="kubectl get pods"
    ["kctx"]="kubectl config current-context"
    ["gs"]="git status"
    ["gc"]="git commit"
    ["gp"]="git push"
    ["gd"]="git diff"
    ["gco"]="git checkout"
    ["gcb"]="git checkout -b"
    ["gcm"]="git checkout master"
    ["gpl"]="git pull"
    ["gpr"]="git pull --rebase"
    ["gprc"]="git pull --rebase --autostash"
    ["gfp"]="git fetch --all; git pull"
)

# Iterate over the aliases and add them
for name in "${!aliases[@]}"; do
    add_alias "$name" "${aliases[$name]}"
done

# Source the updated shell profile if running interactively
if [[ $- == *i* ]]; then
    source "$SHELL_FILE"
    echo "Shell configuration reloaded."
else
    echo "Please restart your terminal or run 'source $SHELL_FILE' to apply changes."
fi

echo "Development environment setup complete."
