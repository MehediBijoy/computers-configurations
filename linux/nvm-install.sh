#!/usr/bin/env bash

colorize() {
    if [ -t 1 ]; then
        printf "\e[%sm%s\e[m\n\n" "$1" "$2"
    else
        echo -n "$2"
    fi
}

colorize 33 "Ubuntu NVM Installer"

install_nvm () {
    colorize 33 "installing nvm ..........."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
    colorize 33 "nvm installed"
}

install_node () {
    
}