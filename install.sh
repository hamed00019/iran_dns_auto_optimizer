#!/bin/bash
#
# Installer for DNS Optimizer - v4 (Hardened, Cross-Distro, Self-Managing)
# This script can install, update, and uninstall the DNS Optimizer tool.
#

# --- Strict Mode ---
set -o errexit
set -o nounset
set -o pipefail

# --- Configuration ---
readonly GITHUB_REPO="hamed00019/iran_dns_auto_optimizer"
readonly BASE_URL="https://raw.githubusercontent.com/${GITHUB_REPO}/main"

# --- System Paths and File Names ---
readonly INSTALL_DIR="/usr/local/bin"
readonly CONFIG_DIR="/etc"
readonly SERVICE_DIR="/etc/systemd/system"
readonly LOGROTATE_DIR="/etc/logrotate.d"
readonly SCRIPT_NAME="dns-optimizer"
readonly CONFIG_NAME="dns_optimizer.conf"
readonly SERVICE_NAME="${SCRIPT_NAME}.service"
readonly TIMER_NAME="${SCRIPT_NAME}.timer"
readonly LOGROTATE_NAME="${SCRIPT_NAME}"
readonly LOG_FILE="/var/log/${SCRIPT_NAME}.log" # Must match config

# --- Colors ---
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_NC='\033[0m'

# --- Functions ---

info() { echo -e "${COLOR_GREEN}INFO:${COLOR_NC} $1"; }
warn() { echo -e "${COLOR_YELLOW}WARN:${COLOR_NC} $1"; }
error() { echo -e "${COLOR_RED}ERROR:${COLOR_NC} $1" >&2; exit 1; }

check_root() {
    if [[ "$EUID" -ne 0 ]]; then
        error "This script must be run as root. Please use 'sudo'."
    fi
}

# Detects distro and installs dependencies
check_and_install_deps() {
    local missing_deps=()
    local required_deps=("curl" "dig" "nproc" "gawk" "parallel")

    info "Checking for required dependencies..."
    for cmd in "${required_deps[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [[ ${#missing_deps[@]} -eq 0 ]]; then
        info "All dependencies are installed."
        return
    fi
    
    warn "Missing dependencies: ${missing_deps[*]}"
    
    local pm=""
    local pkgs=""
    if command -v apt-get &> /dev/null; then
        pm="apt-get"
        pkgs="dnsutils coreutils curl gawk parallel"
    elif command -v dnf &> /dev/null; then
        pm="dnf"
        pkgs="bind-utils coreutils curl gawk parallel"
    elif command -v yum &> /dev/null; then
        pm="yum"
        pkgs="bind-utils coreutils curl gawk parallel"
    elif command -v pacman &> /dev/null; then
        pm="pacman"
        pkgs="dnsutils coreutils curl gawk parallel"
    elif command -v apk &> /dev/null;
        pm="apk"
        pkgs="bind-tools coreutils curl gawk parallel"
    else
        error "Unsupported package manager. Please install missing dependencies manually: ${missing_deps[*]}"
    fi

    read -p "Do you want to install them now? (y/N) " -n 1 -r
    echo
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        info "Updating package list and installing..."
        if [[ "$pm" == "pacman" ]]; then
            sudo "$pm" -Sy --noconfirm $pkgs
        else
            sudo "$pm" update -y && sudo "$pm" install -y $pkgs
        fi
        info "Dependencies installed successfully."
    else
        error "Installation aborted by user."
    fi
}

# Downloads a file from GitHub to a temporary location
download_file() {
    local remote_path="$1"
    local local_path="$2"
    info "Downloading '$remote_path'..."
    if ! curl -fsSL "${BASE_URL}/${remote_path}" -o "$local_path"; then
        error "Failed to download '${remote_path}'. Check URL and internet connection."
    fi
}

install() {
    info "--- Starting DNS Optimizer Installation ---"
    
    check_and_install_deps

    # Create temporary directory
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf -- "$tmp_dir"' EXIT

    # Download files
    download_file "${SCRIPT_NAME}" "${tmp_dir}/${SCRIPT_NAME}"
    download_file "${CONFIG_NAME}" "${tmp_dir}/${CONFIG_NAME}"
    download_file "systemd/${SERVICE_NAME}" "${tmp_dir}/${SERVICE_NAME}"
    download_file "systemd/${TIMER_NAME}" "${tmp_dir}/${TIMER_NAME}"

    # Install script
    info "Installing script to ${INSTALL_DIR}/${SCRIPT_NAME}..."
    mv "${tmp_dir}/${SCRIPT_NAME}" "${INSTALL_DIR}/${SCRIPT_NAME}"
    chmod 755 "${INSTALL_DIR}/${SCRIPT_NAME}"

    # Install config (don't overwrite if it exists)
    if [[ -f "${CONFIG_DIR}/${CONFIG_NAME}" ]]; then
        warn "Existing config file found at ${CONFIG_DIR}/${CONFIG_NAME}. Skipping."
    else
        info "Installing config to ${CONFIG_DIR}/${CONFIG_NAME}..."
        mv "${tmp_dir}/${CONFIG_NAME}" "${CONFIG_DIR}/${CONFIG_NAME}"
        chmod 640 "${CONFIG_DIR}/${CONFIG_NAME}" # User: rw, Group: r, Other: -
    fi

    # Install systemd service and timer
    if ! command -v systemctl &> /dev/null; then
        warn "systemd not found. Skipping service/timer installation."
    else
        info "Installing systemd service and timer..."
        mv "${tmp_dir}/${SERVICE_NAME}" "${SERVICE_DIR}/${SERVICE_NAME}"
        mv "${tmp_dir}/${TIMER_NAME}" "${SERVICE_DIR}/${TIMER_NAME}"
        chmod 644 "${SERVICE_DIR}/${SERVICE_NAME}"
        chmod 644 "${SERVICE_DIR}/${TIMER_NAME}"
        
        info "Reloading systemd daemon and enabling timer..."
        systemctl daemon-reload
        systemctl enable --now "${TIMER_NAME}"
    fi

    # Install logrotate config
    info "Setting up log rotation..."
    local logrotate_content
    logrotate_content="${LOG_FILE} {
    weekly
    rotate 4
    size 10M
    missingok
    notifempty
    compress
    delaycompress
    su root adm
}"
    echo "$logrotate_content" > "${LOGROTATE_DIR}/${LOGROTATE_NAME}"
    chmod 644 "${LOGROTATE_DIR}/${LOGROTATE_NAME}"

    info "--- 🎉 Installation Complete! ---"
    info "You can now use the '${SCRIPT_NAME}' command."
    info "To get started, run: sudo ${SCRIPT_NAME} run"
}

uninstall() {
    info "--- Starting DNS Optimizer Uninstallation ---"
    read -p "Are you sure you want to remove DNS Optimizer and all its files? (y/N) " -n 1 -r
    echo
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        info "Uninstallation cancelled."
        exit 0
    fi

    # Stop and disable systemd timer
    if command -v systemctl &> /dev/null; then
        info "Stopping and disabling systemd timer..."
        systemctl stop "${TIMER_NAME}" 2>/dev/null || true
        systemctl disable "${TIMER_NAME}" 2>/dev/null || true
    fi

    # Remove files
    info "Removing files..."
    rm -f "${INSTALL_DIR}/${SCRIPT_NAME}"
    rm -f "${CONFIG_DIR}/${CONFIG_NAME}"
    rm -f "${SERVICE_DIR}/${SERVICE_NAME}"
    rm -f "${SERVICE_DIR}/${TIMER_NAME}"
    rm -f "${LOGROTATE_DIR}/${LOGROTATE_NAME}"
    rm -f "/var/run/${SCRIPT_NAME}.lock"
    # Ask before deleting log file
    if [[ -f "$LOG_FILE" ]]; then
        read -p "Do you want to delete the log file ($LOG_FILE)? (y/N) " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            rm -f "$LOG_FILE"
        fi
    fi
    
    if command -v systemctl &> /dev/null; then
        systemctl daemon-reload
    fi
    
    info "--- 🗑️ Uninstallation Complete! ---"
}

# --- Main Logic ---
main() {
    check_root
    
    if [[ "${1:-}" == "uninstall" ]]; then
        uninstall
    else
        install
    fi
}

main "$@"
