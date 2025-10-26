# Silhouette

A unified terminal prompt configuration using [Oh My Posh](https://ohmyposh.dev/) for a consistent experience across Windows, WSL, and Linux (including Raspberry Pi).

## Features

- **Cross-platform**: Works on Windows, WSL, and Linux (including Raspberry Pi)
- **Single configuration**: One theme file works everywhere
- **Easy setup**: Automated installation scripts for each platform
- **Clean design**: Displays essential information without clutter
  - OS icon (shows WSL indicator in WSL)
  - Current path
  - Git branch and status
  - Command execution time
  - Exit status indicator

## Prerequisites

- **Windows**: PowerShell 5.1+ and winget
- **Linux/WSL/Raspberry Pi**: bash or zsh
- **All platforms**: A terminal that supports [Nerd Fonts](https://www.nerdfonts.com/)

## Installation

### Windows

1. Clone or download this repository
2. Open PowerShell as Administrator
3. Navigate to the repository directory
4. Run the setup script:

```powershell
.\setup-windows.ps1
```

5. Install a Nerd Font:

```powershell
oh-my-posh font install
```

6. Configure your terminal to use the Nerd Font
7. Restart PowerShell or run `. $PROFILE`

### Linux / WSL / Raspberry Pi

1. Clone or download this repository
2. Navigate to the repository directory
3. Run the setup script:

```bash
./setup-linux.sh
```

4. Install a Nerd Font (download from [Nerd Fonts](https://www.nerdfonts.com/))
   - Recommended: MesloLGM Nerd Font
5. Configure your terminal to use the Nerd Font
6. Restart your shell or run `source ~/.bashrc` (or `~/.zshrc`)

## Quick Setup on Multiple Machines

The easiest way to use this across all your machines:

1. Fork or clone this repository to GitHub/GitLab
2. On each machine, clone your repository:

```bash
git clone https://github.com/yourusername/silhouette.git
cd silhouette
```

3. Run the appropriate setup script for your platform
4. Enjoy a consistent prompt everywhere!

## Available Themes

Silhouette includes three theme variants. All themes display the same information but with different color schemes:

### 1. **silhouette.omp.json** (Original - Simple & Clean)
- Minimalist single-line prompt
- Cyan and green accents
- Best for: Those who prefer a compact, traditional prompt

### 2. **silhouette-matrix.omp.json** (Matrix)
- Dark green (#1a4d2e) and bright green (#4ecca3) color scheme
- Matrix-inspired aesthetic
- Best for: Terminal enthusiasts who love the classic green-on-black look

### 3. **silhouette-sepia.omp.json** (Sepia)
- Warm burnt orange (#8b4513) and wheat/tan (#f5deb3) colors
- Earthy, easy-on-the-eyes palette
- Best for: Those who prefer warmer, mellow tones

All themes show:
- Current directory path
- Git branch and status
- Machine/user information
- OS icon and WSL detection
- Command execution time
- Battery status (on supported systems)
- Current date/time

## Switching Themes

The setup scripts default to the original `silhouette.omp.json`. To use a different theme:

### Linux / WSL / Raspberry Pi

Edit your shell configuration file:

```bash
# For bash users
nano ~/.bashrc

# For zsh users
nano ~/.zshrc
```

Find the line with `oh-my-posh init` and change the config path:

```bash
# Change from:
eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/silhouette.omp.json)"

# To one of:
eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/silhouette-matrix.omp.json)"
eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/silhouette-sepia.omp.json)"
```

Then copy your chosen theme and restart your shell:

```bash
cp silhouette-matrix.omp.json ~/.config/ohmyposh/silhouette-matrix.omp.json
source ~/.bashrc  # or ~/.zshrc
```

### Windows

Edit your PowerShell profile:

```powershell
notepad $PROFILE
```

Find the line with `oh-my-posh init` and change the config path:

```powershell
# Change from:
oh-my-posh init pwsh --config "$env:USERPROFILE\.config\ohmyposh\silhouette.omp.json" | Invoke-Expression

# To one of:
oh-my-posh init pwsh --config "$env:USERPROFILE\.config\ohmyposh\silhouette-matrix.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:USERPROFILE\.config\ohmyposh\silhouette-sepia.omp.json" | Invoke-Expression
```

Then copy your chosen theme and restart PowerShell:

```powershell
Copy-Item silhouette-matrix.omp.json "$env:USERPROFILE\.config\ohmyposh\silhouette-matrix.omp.json"
. $PROFILE
```

## Customization

To create your own theme variant:

1. Copy one of the existing theme files (e.g., `cp silhouette-matrix.omp.json my-theme.omp.json`)
2. Edit the colors, segments, or layout
3. Refer to the [Oh My Posh documentation](https://ohmyposh.dev/docs/configuration/overview) for available options
4. Update your shell config to point to your custom theme
5. Restart your shell to apply changes

## Uninstallation

To remove Silhouette:

### Windows

1. Edit your PowerShell profile: `notepad $PROFILE`
2. Remove the Oh My Posh initialization lines added by Silhouette
3. (Optional) Uninstall oh-my-posh: `winget uninstall JanDeDobbeleer.OhMyPosh`

### Linux / WSL / Raspberry Pi

1. Edit `~/.bashrc` or `~/.zshrc`
2. Remove the Oh My Posh initialization lines added by Silhouette
3. (Optional) Remove oh-my-posh: `rm ~/.local/bin/oh-my-posh`

## Troubleshooting

### Icons not displaying correctly

- Make sure you have a Nerd Font installed
- Ensure your terminal is configured to use the Nerd Font
- Verify font installation: some terminals require a restart

### oh-my-posh command not found

- **Linux/WSL**: Ensure `~/.local/bin` is in your PATH
- **Windows**: Restart PowerShell or update your PATH environment variable
- Try running the setup script again

### Theme not loading

- Verify the theme file exists at `~/.config/ohmyposh/silhouette.omp.json`
- Check your shell profile for the correct initialization command
- Try running oh-my-posh manually: `oh-my-posh init bash --config ~/.config/ohmyposh/silhouette.omp.json`

## License

MIT License - feel free to modify and share!

## Credits

Built with [Oh My Posh](https://ohmyposh.dev/) by Jan De Dobbeleer
