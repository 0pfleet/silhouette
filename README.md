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

## Customization

To customize the prompt:

1. Edit `silhouette.omp.json`
2. Refer to the [Oh My Posh documentation](https://ohmyposh.dev/docs/configuration/overview) for available options
3. Re-run the setup script or restart your shell to apply changes

## Theme Preview

The Silhouette theme displays:

```
🐧 /home/user/projects/silhouette main*  ✓
❯
```

- OS icon (Linux penguin, Windows logo, Apple logo)
- WSL indicator (if in WSL)
- Full current path
- Git branch with modified indicator (*)
- Execution time (if >500ms)
- Success/failure indicator (✓/✗)

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
