#!/bin/bash

addrc () {
    if ! [[ $(cat ~/.bashrc | grep -x "$1") ]]; then
        echo "$1" >> ~/.bashrc
    fi
}

# get current working directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo apt update
sudo apt upgrade -y
sudo apt install -y lzma-dev liblzma-dev libbz2-dev libsqlite3-dev zlib1g-dev libffi-dev wget curl build-essential libssl-dev openssl vim curl wget libncurses-dev libreadline-dev unzip fontconfig pipx

# Add aliases
addrc ''
addrc 'alias ls="ls --color=auto"'

addrc 'alias dc="docker compose"'
source ~/.bashrc

# Add commands
addrc ''
addrc 'export PATH="~/.local/bin:$PATH"'
mkdir -p ~/.local/bin
cd ~/.local/bin
ln -s $SCRIPT_DIR/bin/* .
cd ~

# Install pyenv
if [ ! -d ~/.pyenv ]; then
    curl https://pyenv.run | bash
    addrc ''
    addrc 'export PYENV_ROOT="$HOME/.pyenv"'
    addrc '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
    addrc 'eval "$(pyenv init --path --no-rehash)"'
    source ~/.bashrc
else
    pyenv update
fi

# Install python and tooling
pyenv install 3.12
pyenv global 3.12
source ~/.bashrc
pipx install pipenv
pipx install poetry
poetry self add poetry-dotenv-plugin
poetry config virtualenvs.in-project true
poetry config virtualenvs.prefer-active-python true
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install nerd fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget -O "MesloLGS NF Regular.ttf" "https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf"
wget -O "MesloLGS NF Bold.ttf" "https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold.ttf"
wget -O "MesloLGS NF Italic.ttf" "https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Italic.ttf"
wget -O "MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold%20Italic.ttf"
fc-cache -fv
cd ~

# Install starship
curl -sS https://starship.rs/install.sh | sudo sh -s -- -y
addrc ''
addrc 'export VIRTUAL_ENV_DISABLE_PROMPT=1'
addrc 'export POETRY_VIRTUALENVS_PROMPT=" "'
addrc 'export POETRY_VIRTUALENVS_IN_PROJECT=true'
addrc 'eval "$(starship init bash)"'
mkdir -p ~/.config
cd ~/.config
rm -rf starship.toml
ln -s $SCRIPT_DIR/starship.toml .
cd ~
source ~/.bashrc
