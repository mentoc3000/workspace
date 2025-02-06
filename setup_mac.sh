#!/bin/bash

# get current working directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

xcode-select --install

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for current session
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install useful tools
brew install --cask alt-tab eul rectangle hammerspoon vlc font-hack-nerd-font bzip2 ffmpeg readline sqlite3 python-tk neovim zsh-syntax-highlighting zsh-autosuggestions pipx

# Scroll up to reveal app expose
defaults write com.apple.dock "scroll-to-open" -bool "true" && killall Dock

# Add aliases
echo '' >> ~/.zshrc
echo 'alias ls="ls --color=auto"' >> ~/.zshrc
echo 'alias la="ls -lah"' >> ~/.zshrc
echo 'alias dc="docker compose"' >> ~/.zshrc
source ~/.zshrc

# Add commands
echo '' >> ~/.zshrc
echo 'export PATH="~/.local/bin:$PATH"' >> ~/.zshrc
mkdir -p ~/.local/bin
cd ~/.local/bin
ln -s $SCRIPT_DIR/bin/* .
cd ~

# Install python and tooling
brew install pyenv
pyenv install 3.12
pyenv global 3.12
source ~/.zshrc
pipx install pipenv
pipx install poetry
poetry self add poetry-dotenv-plugin
poetry config virtualenvs.in-project true
poetry config virtualenvs.prefer-active-python true
brew install uv

# Install node and tooling
brew install nvm pnpm
nvm install node
nvm use node

# Install starship
brew install starship
echo '' >> ~/.zshrc
echo 'export VIRTUAL_ENV_DISABLE_PROMPT=1' >> ~/.zshrc
echo 'export POETRY_VIRTUALENVS_PROMPT=" "' >> ~/.zshrc
echo 'export POETRY_VIRTUALENVS_IN_PROJECT=true' >> ~/.zshrc
echo 'eval "$(starship init bash)"' >> ~/.zshrc
mkdir -p ~/.config
cd ~/.config
rm -rf starship.toml
ln -s $SCRIPT_DIR/starship.toml .
cd ~
source ~/.zshrc
