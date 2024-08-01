#!/bin/bash

# get current working directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo apt update
sudo apt install -y lzma-dev liblzma-dev libbz2-dev libsqlite3-dev zlib1g-dev libffi-dev wget curl build-essential libssl-dev openssl vim curl wget libncurses-dev libreadline-dev unzip fontconfig

# Add aliases
echo '' >> ~/.bashrc
echo 'alias ls="ls --color=auto"' >> ~/.bashrc
echo 'alias la="ls -lah"' >> ~/.bashrc
echo 'alias dc="docker compose"' >> ~/.bashrc
source ~/.bashrc

# Add commands
echo '' >> ~/.bashrc
echo 'export PATH="~/.local/bin:$PATH"' >> ~/.bashrc
mkdir -p ~/.local/bin
cd ~/.local/bin
ln -s $SCRIPT_DIR/bin/* .
cd ~

# Install pyenv
curl https://pyenv.run | bash
echo '' >> ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init --path --no-rehash)"' >> ~/.bashrc
source ~/.bashrc

# Install python and tooling
pyenv install 3.11.9
pyenv global 3.11.9
source ~/.bashrc
pipx install pipenv
pipx install poetry
poetry self add poetry-dotenv-plugin

# Install nerd fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip 
rm JetBrainsMono.zip
fc-cache -fv
cd ~

# Install starship
curl -sS https://starship.rs/install.sh | sudo sh -s -- -y
echo '' >> ~/.bashrc
echo 'export VIRTUAL_ENV_DISABLE_PROMPT=1' >> ~/.bashrc
echo 'export POETRY_VIRTUALENVS_PROMPT=" "' >> ~/.bashrc
echo 'eval "$(starship init bash)"' >> ~/.bashrc
mkdir -p ~/.config
cd ~/.config
rm -rf starship.toml
ln -s $SCRIPT_DIR/starship.toml .
cd ~
source ~/.bashrc