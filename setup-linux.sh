#!/bin/bash

set -e

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emojis
ROCKET="🚀"
CHECK="✅"
CROSS="❌"
WARNING="⚠️"
PACKAGE="📦"
PAINT="🎨"
FONT="🔤"
SHELL="🐚"
PI="🥧"

echo -e "${CYAN}"
cat << "EOF"
   _____ _ _ _                       _   _
  / ____(_) | |                     | | | |
 | (___  _| | |__   ___  _   _  ___| |_| |_ ___
  \___ \| | | '_ \ / _ \| | | |/ _ \ __| __/ _ \
  ____) | | | | | | (_) | |_| |  __/ |_| ||  __/
 |_____/|_|_|_| |_|\___/ \__,_|\___|\__|\__\___|

EOF
echo -e "${NC}"
echo -e "${PURPLE}Oh My Posh Terminal Setup${NC}"
echo -e "${CYAN}For Linux, WSL, and Raspberry Pi${NC}"
echo ""

# Determine script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect if running on Raspberry Pi
IS_RASPBERRY_PI=false
if [ -f /proc/device-tree/model ]; then
    if grep -q "Raspberry Pi" /proc/device-tree/model 2>/dev/null; then
        IS_RASPBERRY_PI=true
        PI_MODEL=$(tr -d '\0' < /proc/device-tree/model)
        echo -e "${PI} ${GREEN}Raspberry Pi detected: ${PI_MODEL}${NC}"
        echo ""
    fi
fi

# ============================================
# 1. Check Dependencies
# ============================================
echo -e "${PACKAGE} ${BLUE}Checking dependencies...${NC}"

MISSING_DEPS=()

if ! command -v curl &> /dev/null; then
    MISSING_DEPS+=("curl")
fi

if ! command -v unzip &> /dev/null; then
    MISSING_DEPS+=("unzip")
fi

if ! command -v git &> /dev/null; then
    MISSING_DEPS+=("git")
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo -e "${WARNING} ${YELLOW}Missing dependencies: ${MISSING_DEPS[*]}${NC}"
    echo -e "${PACKAGE} ${BLUE}Installing dependencies...${NC}"

    if command -v apt-get &> /dev/null; then
        sudo apt-get update -qq
        sudo apt-get install -y -qq ${MISSING_DEPS[@]}
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y -q ${MISSING_DEPS[@]}
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm ${MISSING_DEPS[@]}
    else
        echo -e "${CROSS} ${RED}Could not install dependencies. Please install manually: ${MISSING_DEPS[*]}${NC}"
        exit 1
    fi
    echo -e "${CHECK} ${GREEN}Dependencies installed!${NC}"
else
    echo -e "${CHECK} ${GREEN}All dependencies present!${NC}"
fi

echo ""

# ============================================
# 2. Detect Architecture
# ============================================
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        OMP_ARCH="amd64"
        ;;
    aarch64|arm64)
        OMP_ARCH="arm64"
        ;;
    armv7l)
        OMP_ARCH="arm"
        ;;
    *)
        echo -e "${WARNING} ${YELLOW}Unsupported architecture: $ARCH${NC}"
        echo -e "   Defaulting to amd64, but this may not work."
        OMP_ARCH="amd64"
        ;;
esac

# ============================================
# 3. Install Oh My Posh
# ============================================
if ! command -v oh-my-posh &> /dev/null; then
    echo -e "${PACKAGE} ${BLUE}Installing oh-my-posh...${NC}"

    # Create bin directory if it doesn't exist
    mkdir -p "$HOME/.local/bin"

    # Download and install oh-my-posh
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin" > /dev/null 2>&1

    # Make sure it's in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    echo -e "${CHECK} ${GREEN}Oh-my-posh installed successfully!${NC}"
else
    echo -e "${CHECK} ${GREEN}Oh-my-posh is already installed${NC}"
fi

echo ""

# ============================================
# 4. Install Nerd Font (MesloLGM)
# ============================================
echo -e "${FONT} ${BLUE}Checking for Nerd Font installation...${NC}"

FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="MesloLGM Nerd Font"

if fc-list 2>/dev/null | grep -qi "MesloLGM"; then
    echo -e "${CHECK} ${GREEN}Nerd Font already installed!${NC}"
else
    echo -e "${PACKAGE} ${BLUE}Installing MesloLGM Nerd Font...${NC}"

    mkdir -p "$FONT_DIR"
    TEMP_DIR=$(mktemp -d)

    # Download MesloLGM Nerd Font
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
    curl -fsSL "$FONT_URL" -o "$TEMP_DIR/Meslo.zip"

    # Extract to font directory
    unzip -q "$TEMP_DIR/Meslo.zip" -d "$FONT_DIR" "MesloLGMNerdFont-*.ttf" 2>/dev/null || true

    # Update font cache
    if command -v fc-cache &> /dev/null; then
        fc-cache -f "$FONT_DIR" > /dev/null 2>&1
    fi

    # Cleanup
    rm -rf "$TEMP_DIR"

    echo -e "${CHECK} ${GREEN}Nerd Font installed!${NC}"
    echo -e "${WARNING} ${YELLOW}Remember to configure your terminal to use 'MesloLGM Nerd Font'${NC}"
fi

echo ""

# ============================================
# 5. Theme Selection
# ============================================
echo -e "${PAINT} ${BLUE}Choose your theme:${NC}"
echo ""
echo -e "  ${CYAN}1)${NC} ${GREEN}Silhouette Original${NC} - Clean & minimal (cyan/green)"
echo -e "  ${CYAN}2)${NC} ${GREEN}Matrix${NC} - Dark green matrix-inspired theme"
echo -e "  ${CYAN}3)${NC} ${GREEN}Sepia${NC} - Warm earthy tones (burnt orange/wheat)"
echo ""
read -p "$(echo -e ${CYAN}Enter your choice [1-3, default: 1]:${NC} )" THEME_CHOICE

case $THEME_CHOICE in
    2)
        THEME_FILE="silhouette-matrix.omp.json"
        THEME_NAME="Matrix"
        ;;
    3)
        THEME_FILE="silhouette-sepia.omp.json"
        THEME_NAME="Sepia"
        ;;
    *)
        THEME_FILE="silhouette.omp.json"
        THEME_NAME="Original"
        ;;
esac

echo -e "${CHECK} ${GREEN}Selected: ${THEME_NAME}${NC}"
echo ""

# ============================================
# 6. Copy Theme Files
# ============================================
echo -e "${PACKAGE} ${BLUE}Installing theme files...${NC}"

# Create oh-my-posh config directory
mkdir -p "$HOME/.config/ohmyposh"

# Check if theme file exists
if [ ! -f "$SCRIPT_DIR/$THEME_FILE" ]; then
    echo -e "${CROSS} ${RED}Error: Theme file not found at $SCRIPT_DIR/$THEME_FILE${NC}"
    exit 1
fi

# Copy selected theme
cp "$SCRIPT_DIR/$THEME_FILE" "$HOME/.config/ohmyposh/silhouette.omp.json"

# Also copy all theme variants for easy switching later
for theme in silhouette.omp.json silhouette-matrix.omp.json silhouette-sepia.omp.json; do
    if [ -f "$SCRIPT_DIR/$theme" ]; then
        cp "$SCRIPT_DIR/$theme" "$HOME/.config/ohmyposh/$theme"
    fi
done

echo -e "${CHECK} ${GREEN}Theme files installed!${NC}"
echo ""

# ============================================
# 7. Configure Shell
# ============================================
setup_shell() {
    local shell_name=$1
    local rc_file=$2
    local init_cmd=$3

    echo -e "${SHELL} ${BLUE}Setting up $shell_name...${NC}"

    if [ ! -f "$rc_file" ]; then
        touch "$rc_file"
    fi

    # Backup existing config
    if [ -f "$rc_file" ]; then
        cp "$rc_file" "${rc_file}.silhouette.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Remove ALL existing oh-my-posh configurations to avoid duplicates
    if grep -q "oh-my-posh init" "$rc_file" 2>/dev/null; then
        echo -e "${WARNING} ${YELLOW}Removing existing oh-my-posh configuration...${NC}"

        # Remove all oh-my-posh related lines
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' '/oh-my-posh init/d' "$rc_file"
            sed -i '' '/# Oh My Posh/d' "$rc_file"
        else
            sed -i '/oh-my-posh init/d' "$rc_file"
            sed -i '/# Oh My Posh/d' "$rc_file"
        fi
    fi

    # Ensure ~/.local/bin is in PATH
    if ! grep -q 'PATH.*\.local/bin' "$rc_file" 2>/dev/null; then
        echo "" >> "$rc_file"
        echo "# Add local bin to PATH for oh-my-posh" >> "$rc_file"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc_file"
    fi

    # Add fresh configuration
    echo "" >> "$rc_file"
    echo "# Oh My Posh initialization (added by Silhouette)" >> "$rc_file"
    echo "$init_cmd" >> "$rc_file"

    echo -e "${CHECK} ${GREEN}$shell_name configured!${NC}"
}

# Detect and setup shells
SHELLS_CONFIGURED=()

# Bash
if [ -f "$HOME/.bashrc" ]; then
    setup_shell "bash" "$HOME/.bashrc" 'eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/silhouette.omp.json)"'
    SHELLS_CONFIGURED+=("bash")
fi

# Zsh
if [ -f "$HOME/.zshrc" ]; then
    setup_shell "zsh" "$HOME/.zshrc" 'eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/silhouette.omp.json)"'
    SHELLS_CONFIGURED+=("zsh")
fi

# Fish
if [ -d "$HOME/.config/fish" ]; then
    FISH_CONFIG="$HOME/.config/fish/config.fish"
    setup_shell "fish" "$FISH_CONFIG" 'oh-my-posh init fish --config ~/.config/ohmyposh/silhouette.omp.json | source'
    SHELLS_CONFIGURED+=("fish")
fi

if [ ${#SHELLS_CONFIGURED[@]} -eq 0 ]; then
    echo -e "${WARNING} ${YELLOW}No shell configuration files found${NC}"
    echo -e "   Please manually add oh-my-posh initialization to your shell config"
fi

echo ""

# ============================================
# 8. Validation
# ============================================
echo -e "${ROCKET} ${BLUE}Validating installation...${NC}"

VALIDATION_PASSED=true

# Check oh-my-posh binary
if ! command -v oh-my-posh &> /dev/null; then
    echo -e "${CROSS} ${RED}oh-my-posh not found in PATH${NC}"
    VALIDATION_PASSED=false
else
    echo -e "${CHECK} ${GREEN}oh-my-posh binary: OK${NC}"
fi

# Check theme file
if [ -f "$HOME/.config/ohmyposh/silhouette.omp.json" ]; then
    echo -e "${CHECK} ${GREEN}Theme file: OK${NC}"
else
    echo -e "${CROSS} ${RED}Theme file not found${NC}"
    VALIDATION_PASSED=false
fi

# Test oh-my-posh can load theme
if oh-my-posh print primary --config "$HOME/.config/ohmyposh/silhouette.omp.json" > /dev/null 2>&1; then
    echo -e "${CHECK} ${GREEN}Theme validation: OK${NC}"
else
    echo -e "${CROSS} ${RED}Theme validation failed${NC}"
    VALIDATION_PASSED=false
fi

echo ""

# ============================================
# 9. Success!
# ============================================
if [ "$VALIDATION_PASSED" = true ]; then
    echo -e "${GREEN}"
    cat << "EOF"
   _____ _    _  _____ _____ ______  _____ _____ _
  / ____| |  | |/ ____/ ____|  ____|/ ____/ ____| |
 | (___ | |  | | |   | |    | |__  | (___| (___ | |
  \___ \| |  | | |   | |    |  __|  \___ \\___ \| |
  ____) | |__| | |___| |____| |____ ____) |___) |_|
 |_____/ \____/ \_____\_____|______|_____/_____/(_)

EOF
    echo -e "${NC}"
    echo -e "${CHECK} ${GREEN}Silhouette installed successfully!${NC}"
    echo ""

    if [ ${#SHELLS_CONFIGURED[@]} -gt 0 ]; then
        echo -e "${PURPLE}📝 Next steps:${NC}"
        echo ""
        echo -e "  ${CYAN}1.${NC} Configure your terminal to use ${GREEN}MesloLGM Nerd Font${NC}"
        echo -e "     (Check your terminal's preferences/settings)"
        echo ""
        echo -e "  ${CYAN}2.${NC} Restart your shell or run:"
        for shell in "${SHELLS_CONFIGURED[@]}"; do
            case $shell in
                bash)
                    echo -e "     ${YELLOW}source ~/.bashrc${NC}"
                    ;;
                zsh)
                    echo -e "     ${YELLOW}source ~/.zshrc${NC}"
                    ;;
                fish)
                    echo -e "     ${YELLOW}source ~/.config/fish/config.fish${NC}"
                    ;;
            esac
        done
        echo ""
        echo -e "${PURPLE}💡 Tips:${NC}"
        echo -e "  • Switch themes: Edit your shell config and change the theme file name"
        echo -e "  • Available themes: silhouette.omp.json, silhouette-matrix.omp.json, silhouette-sepia.omp.json"
        echo -e "  • Backup created: Your original config was backed up with .silhouette.backup suffix"
        echo ""

        # Auto-apply if possible
        read -p "$(echo -e ${CYAN}Would you like to apply changes now? [Y/n]:${NC} )" APPLY_NOW
        if [[ "$APPLY_NOW" != "n" && "$APPLY_NOW" != "N" ]]; then
            echo ""
            echo -e "${ROCKET} ${BLUE}Applying changes...${NC}"

            # Determine current shell
            CURRENT_SHELL=$(basename "$SHELL")
            case $CURRENT_SHELL in
                bash)
                    exec bash
                    ;;
                zsh)
                    exec zsh
                    ;;
                fish)
                    exec fish
                    ;;
                *)
                    echo -e "${WARNING} ${YELLOW}Please restart your shell manually${NC}"
                    ;;
            esac
        fi
    fi
else
    echo -e "${CROSS} ${RED}Installation completed with errors${NC}"
    echo -e "Please check the messages above and try again"
    exit 1
fi
