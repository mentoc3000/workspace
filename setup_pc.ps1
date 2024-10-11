# Get current working directory
$SCRIPT_DIR = (Get-Location).Path

# Update Windows system (no direct equivalent to apt update/upgrade in PowerShell)

# Install required packages via winget
winget install --id=Python.Python.3 --source winget --silent
winget install --id=OpenSSL.OpenSSL --source winget --silent
winget install --id=GnuWin32.Bzip2 --source winget --silent
winget install --id=Microsoft.WindowsTerminal --source winget --silent
winget install --id=Git.Git --source winget --silent
winget install --id=Starship.Starship --source winget --silent
winget install --id=Microsoft.VisualStudioCode --source winget --silent

# Add aliases
$profilePath = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

Add-Content -Path $profilePath -Value "`nSet-Alias ls 'Get-ChildItem -Force -Recurse'"
Add-Content -Path $profilePath -Value "`nSet-Alias la 'Get-ChildItem -Hidden -Force -Recurse -File'"
Add-Content -Path $profilePath -Value "`nSet-Alias dc 'docker-compose'"

# Add custom paths
Add-Content -Path $profilePath -Value "`n$env:Path += ';$HOME\AppData\Local\Microsoft\WindowsApps'"

# Install pyenv-win
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://pyenv-win.github.io/pyenv-win/install.ps1')

# Add pyenv to PATH and initialize it
Add-Content -Path $profilePath -Value "`n$env:PYENV = '$HOME\.pyenv'"
Add-Content -Path $profilePath -Value "`n$env:Path += ';$env:PYENV\bin;$env:PYENV\shims'"
Add-Content -Path $profilePath -Value "`npyenv rehash"

# Source the PowerShell profile
. $profilePath

# Install Python version 3.11.9 using pyenv
pyenv install 3.11.9
pyenv global 3.11.9

# Install pipx, poetry, and tooling
pip install --user pipx
pipx ensurepath
pipx install pipenv
pipx install poetry

# Set poetry configuration
poetry config virtualenvs.in-project true
poetry config virtualenvs.prefer-active-python true
poetry self add poetry-dotenv-plugin

# Install Nerd Fonts (using scoop for easy download and unzip)
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop install nerd-fonts

# Install starship prompt
Invoke-Expression (& { $(iwr -useb https://starship.rs/install.ps1) }) -Force

# Configure Starship
$starshipConfigPath = "$HOME\AppData\Roaming\starship.toml"
New-Item -ItemType Directory -Force -Path "$HOME\AppData\Roaming"
Remove-Item -Path $starshipConfigPath -Force
New-Item -ItemType SymbolicLink -Path $starshipConfigPath -Target "$SCRIPT_DIR\starship.toml"

# Update PowerShell profile for starship prompt
Add-Content -Path $profilePath -Value "`nInvoke-Expression (&starship init powershell)"

# Source the PowerShell profile to apply changes
. $profilePath
