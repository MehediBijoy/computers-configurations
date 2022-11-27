#!/usr/bin/env bash

colorize() {
    if [ -t 1 ]; then
        printf "\e[%sm%s\e[m\n\n" "$1" "$2"
    else
        echo -n "$2"
    fi
}

echo
colorize 33 "Ubuntu Pyenv Installer"

current_version=`python3 -V | grep -Eo '([0-9]{1,3}[\.]){2}[0-9]{1,3}'`
echo "The current Python version is: ${current_version} (system)"

python_version=`curl --silent https://www.python.org/downloads/ \
                | grep https://www.python.org/ftp/python/ \
                | grep -Eo '([0-9]{1,3}[\.]){2}[0-9]{1,3}' \
                | head -1`

echo "The latest Python version is: ${python_version}"
echo


apt_update(){
    colorize 92 "Updating system packages lists"
    sudo apt update
    echo
}

python_package_manager_install() {
    colorize 92 "pip and pipenv install"
    sudo apt install -y python3-pip
    sudo pip install pipenv
    colorize 92 "pip and pipenv install done!"
}

install_python_dependencies() {
    colorize 92 "Installing Python build dependencies"
    sudo apt install -y \
        make \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget \
        curl \
        llvm \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        libffi-dev \
        liblzma-dev
    colorize 92 "Python build dependencies installed!"
}

install_git(){
    colorize 92 "Installing Git"
    sudo apt install -y git
    echo
}

write_pyenv_config() {
    echo >> $1
    echo "# Pyenv configuration">> $1
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $1
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $1
    echo 'eval "$(pyenv init -)"' >> $1
    echo >> $1
}

install_pyenv(){
    colorize 92 'Installing Pyenv'
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    echo

    colorize 92 'Writing Pyenv config to ./bashrc and ./zshrc file'
    [ -f ~/.bashrc ] && write_pyenv_config ~/.bashrc
    [ -f ~/.zshrc ] && write_pyenv_config ~/.zshrc
    colorize 92 'configuration written done!'
}

create_symlink_to_python3(){
    sudo ln -s /usr/bin/python3 /usr/bin/python
}

install_python(){
    colorize 92 "Installing Python $python_version"
    pyenv install $python_version
}

set_python_global(){
    colorize 92 "Setting Python $python_version as global version"
    pyenv global $python_version
    colorize 92 "Python $python_version successfull set global version"
}

restart_current_shell(){
    exec $SHELL
}

done_message(){
    echo
    echo "Installed successfully"
    echo "To uninstall Pyenv just delete them from ${HOME}/.bashrc file, and"
    echo "then delete ${PYENV_ROOT} directory"
    echo 'Done!'
}

install_minimum(){
    apt_update
    install_git
    python_package_manager_install
    install_python_dependencies
    install_pyenv
    create_symlink_to_python3
}

if [ ! -d ~/.pyenv ];  then 
    install_minimum
    install_python
    set_python_global
    done_message
    restart_current_shell
else
    echo "Pyenv already installed"
fi
