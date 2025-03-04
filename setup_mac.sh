#!/bin/bash

addrc () {
    if ! [[ $(cat ~/.zshrc | grep -x "$1") ]]; then
        echo "$1" >> ~/.zshrc
    fi
}

# get current working directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

xcode-select --install

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for current session
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

addrc 'eval "$(/opt/homebrew/bin/brew shellenv)"'

addrc 'export PATH="/opt/homebrew/bin:$PATH"'
addrc 'export PATH="/opt/homebrew/sbin:$PATH"'
addrc 'source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
addrc 'source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

# Install useful tools
brew install font-hack-nerd-font bzip2 ffmpeg readline sqlite3 python-tk neovim zsh-syntax-highlighting zsh-autosuggestions pipx
brew install --cask alt-tab eul rectangle hammerspoon vlc

# Scroll up to reveal app expose
defaults write com.apple.dock "scroll-to-open" -bool "true" && killall Dock

# Show hidden files by default
defaults write com.apple.finder "AppleShowAllFiles" -bool "true" && killall Finder

# Default to list view
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv" && killall Finder

# Default to search current folder
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf" && killall Finder

# Add aliases
addrc ''
addrc 'alias ls="ls --color=auto"'
addrc 'alias la="ls -lah"'
addrc 'alias dc="docker compose"'
source ~/.zshrc

# Add commands
addrc ''
addrc 'export PATH="$HOME/.local/bin:$PATH"'
mkdir -p ~/.local/bin
cd ~/.local/bin
ln -s $SCRIPT_DIR/bin/* .
cd ~

# Install python and tooling
brew install pyenv
addrc 'export PATH="$HOME/.pyenv/bin:$PATH"'
addrc 'export PIPENV_PYTHON="$HOME/.pyenv/shims/python"'
addrc 'eval "$(pyenv init --path --no-rehash)"'
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
addrc ''
addrc 'export VIRTUAL_ENV_DISABLE_PROMPT=1'
addrc 'export POETRY_VIRTUALENVS_PROMPT=" "'
addrc 'export POETRY_VIRTUALENVS_IN_PROJECT=true'
addrc 'eval "$(starship init zsh)"'
mkdir -p ~/.config
cd ~/.config
rm -rf starship.toml
ln -s $SCRIPT_DIR/starship.toml .
cd ~
source ~/.zshrc
