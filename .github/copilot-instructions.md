# Slime-hatena Dotfiles System

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

This is a Japanese-language dotfiles management system that configures development environments for Unix-like systems (macOS and Linux) and Windows. The system uses Homebrew as the primary package manager and the `runme` tool to execute markdown-embedded commands.

## Quick Overview
- **Primary Languages**: Shell scripting (bash), PowerShell (Windows)
- **Main Dependencies**: git, curl, sudo, Homebrew, runme tool
- **Supported Platforms**: macOS (Intel/Apple Silicon), Linux (Ubuntu/similar), Windows 10/11
- **Installation Location**: `$HOME/.dotfiles` 
- **Default Shell**: bash

## Working Effectively

### Bootstrap and Installation
**NEVER CANCEL long-running commands. Installation can take 30-60+ minutes total depending on package selection and network speed.**

1. **Prerequisites**: Ensure git is installed and you have sudo access
2. **Main installation** (production - use this by default):
   ```bash
   /bin/bash -c "$(curl -fsSL https://git.io/dot-slime-hatena)"
   ```
3. **Development branch installation** (for testing):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Slime-hatena/dotfiles/develop/scripts/clone.sh) develop"
   ```

### Core Installation Process and Timing
**CRITICAL: Set timeout to 90+ minutes for full installation. NEVER CANCEL.**

The installation follows this sequence:
1. **Repository cloning**: ~5 seconds
2. **Homebrew installation**: 20-45 minutes (NEVER CANCEL - network dependent)
3. **Essential packages (runme, etc.)**: 5-15 minutes
4. **User package selection** (interactive prompts):
   - Minimum packages: ~10-20 minutes
   - Development packages: +15-30 minutes  
   - Extra packages: +5-15 minutes
5. **Configuration file linking**: ~5 seconds

**Expected total time: 30-90 minutes**

### Manual Installation Steps (if needed)
If the automated script fails, run these commands manually from the repository root:

```bash
# Set up basic directories and files
mkdir -p "$HOME/.config" "$HOME/Development"
touch "$HOME/.bash_path"

# Install Homebrew on Linux (if not present)
sudo apt update && sudo apt install -y build-essential
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install runme and core packages
brew install runme
```

### Testing and Validation
**NEVER CANCEL: Docker build takes 5-15 minutes, full test takes 30-60+ minutes**

```bash
# Build test environment - NEVER CANCEL, takes 5-15 minutes
docker build -t dotfiles_test:local -f ./Dockerfile . 

# Run full installation test - NEVER CANCEL, takes 30-60+ minutes
docker run -it dotfiles_test:local
```

**Note**: Docker testing may fail in environments with restricted network access to `formulae.brew.sh`.

### Update Existing Installation
```bash
# From any directory
~/.dotfiles/scripts/update.sh

# Or with specific branch
~/.dotfiles/scripts/update.sh develop
```

## Environment Configuration

### Package Management
The system uses Homebrew with three package tiers:

1. **Minimum packages** (`env/homebrew/min/Brewfile`):
   - Essential tools: git, gcc, go, zsh, tmux, neovim, fzf, jq, runme
   - Git tools: gh, ghq, gitui, lazygit, tig
   - Shell enhancements: zsh plugins, powerlevel10k

2. **Development packages** (`env/homebrew/dev/Brewfile`):
   - Web development: php, composer, hugo
   - System tools: nkf, nmap, proto

3. **Extra packages** (`env/homebrew/extra/Brewfile`):
   - Media tools: ffmpeg, yt-dlp

### Configuration Modules
Each tool has its own directory in `env/` with a README.md containing `runme` commands:

- `env/bash/` - Bash shell configuration  
- `env/zsh/` - Zsh shell with powerlevel10k theme
- `env/git/` - Git configuration with VS Code integration
- `env/tmux/` - Terminal multiplexer with tpm plugin manager
- `env/ghostty/` - Ghostty terminal emulator
- `env/wezterm/` - WezTerm terminal emulator
- `env/darwin/` - macOS-specific settings
- `env/homebrew/` - Package management
- `env/ssh/` - SSH configuration
- `env/go/` - Go development environment

### Runme Commands
Each configuration module uses `runme` to execute markdown code blocks:

```bash
# From any env subdirectory, run specific tasks
runme run bash-install        # Set up bash configuration
runme run git-install         # Set up git configuration  
runme run brew-add-min        # Add minimum packages to Brewfile
runme run brew-install        # Install all packages from Brewfile
```

## Common Tasks

### Adding New Packages
1. Edit appropriate Brewfile in `env/homebrew/{min,dev,extra}/`
2. Run `runme run brew-install` from `env/homebrew/` directory
3. Test that packages install correctly

### Modifying Shell Configuration
1. Edit files in `env/bash/` or `env/zsh/` directories
2. Run `runme run bash-install` or `runme run zsh-install`
3. Source the configuration: `source ~/.bashrc` or restart shell

### Windows Support
Windows installation uses winget through PowerShell:
```powershell
Invoke-WebRequest "https://raw.githubusercontent.com/slime-hatena/dotfiles/develop/windows/winget.ps1" -OutFile "C:\Windows\Temp\winget.ps1"
powershell -NoProfile -ExecutionPolicy Unrestricted "C:\Windows\Temp\winget.ps1"
```

## Validation Scenarios
After making changes, always test these scenarios:

### Complete Installation Test
1. Run Docker test: `docker build -t dotfiles_test:local -f ./Dockerfile .`
2. Execute container: `docker run -it dotfiles_test:local`
3. Verify Homebrew installs correctly (allow 30-60 minutes)
4. Confirm configurations are properly linked

### Configuration Validation
1. Test bash configuration: `bash -l` should load without errors
2. Test git configuration: `git config --list` should show custom settings
3. Verify symlinks: `ls -la ~/{.bashrc,.profile,.gitconfig}` should show proper links
4. Test custom aliases: `git pwd`, `git me`, etc.

### Package Installation Validation  
1. Test runme availability: `runme --version`
2. Test essential tools: `fzf --version`, `jq --version`, `neovim --version`
3. Test git tools: `gh --version`, `lazygit --version`

## Critical Information

### Timing Expectations - NEVER CANCEL
- **Docker build**: 5-15 minutes
- **Homebrew installation**: 20-45 minutes 
- **Package installation**: 10-60 minutes (varies by selection)
- **Full installation**: 30-90 minutes total
- **Always set timeouts of 90+ minutes for installation commands**

### Interactive Prompts
The installation process includes interactive prompts:
- Confirmation to proceed (after 5-second warning)
- Optional development packages installation
- Optional extra packages installation  
- File backup confirmations for existing configs

### Network Dependencies
- Requires access to github.com, raw.githubusercontent.com
- Requires access to brew.sh, formulae.brew.sh
- Requires access to various package repositories
- May fail in restricted network environments

### File Backup System
- Existing configuration files are backed up to `~/.dotfiles/backup/`
- Backup files are timestamped: `filename.timestamp`
- Original files are replaced with symbolic links

### Branch Strategy  
- `main` branch: Stable production configuration
- `develop` branch: Active development and testing
- Only `develop` and `hotfix` branches can merge to `main`

## Important File Locations

### Repository Structure
```
/home/user/.dotfiles/
├── scripts/          # Installation and update scripts
├── env/             # Configuration modules
├── backup/          # Backup of replaced files  
├── Dockerfile       # Testing environment
└── README.md        # Basic usage instructions
```

### User Configuration Files (created by installation)
```
~/.bashrc           -> ~/.dotfiles/env/bash/.bashrc
~/.profile          -> ~/.dotfiles/env/bash/.profile  
~/.gitconfig        -> ~/.dotfiles/env/git/.gitconfig
~/.gitconfig_users  # User-specific git configuration
~/.bash_path        # Custom PATH additions
```

### Never Modify These Directly
- Do not edit linked configuration files in home directory
- Always edit source files in `~/.dotfiles/env/` directories
- Do not manually modify Brewfile - use runme commands

## Error Recovery
If installation fails:
1. Check network connectivity to github.com and formulae.brew.sh
2. Verify sudo access is available
3. Check available disk space (Homebrew needs ~2GB)
4. Review logs for specific error messages
5. Try the manual installation steps above
6. For network issues, wait and retry - do not modify scripts

Remember: **This system modifies your shell environment significantly. Always backup important configurations before running.**