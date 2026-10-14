#!/usr/bin/env bash
# Syncro Linux USB installer - v1.0
# Edit this URL for the correct customer AND policy folder before each visit.
# Keep the single quotes. Paste the full Copy Link URL on ONE line.
# Syncro download links expire after 7 days. Internet access is required.
SYNCRO_URL=''

# auto: bypass OS check on Debian/RHEL derivatives such as Zorin/Rocky.
# yes: always bypass. no: leave the vendor's OS check enabled.
SKIP_OS_CHECK='auto'

# Run from a terminal: bash "/path/to/Install-Syncro-Linux.sh"
# No chmod required on the USB stick, including FAT/exFAT or noexec mounts.
# Official instructions:
# https://docs.syncrosecure.com/agents-alerts-automations/work-with-the-syncro-linux-agent

set -Eeuo pipefail
umask 077
fail() { printf '\nERROR: %s\n' "$*" >&2; exit 1; }
trap 'printf "\nStopped at line %s (exit %s). Installation was not verified.\n" "$LINENO" "$?" >&2' ERR

[[ $(uname -s) == Linux ]] || fail 'This script requires Linux.'
case "$(uname -m)" in
    x86_64) agent_arch=x64 ;;
    aarch64|arm64) agent_arch=arm64 ;;
    *) fail 'Only x86_64 and arm64 Linux systems are supported.' ;;
esac

# Repair common formatting from email, web pages, and Markdown.
# Do not URL-encode the entire link: that would break its query/signature.
url=$SYNCRO_URL
url=${url//$'\r'/}
url=${url//\\&/'&'}
url=${url//&amp;/'&'}
url=${url//&#38;/'&'}
url=${url//&#x26;/'&'}
url="${url#"${url%%[![:space:]]*}"}"
url="${url%"${url##*[![:space:]]}"}"
[[ $url != *[[:space:]]* ]] || fail 'The URL contains spaces/newlines. Paste one complete URL.'
[[ $url =~ ^https://[A-Za-z0-9.-]+/download_linux_agent_installers\? ]] ||
    fail 'Set SYNCRO_URL at the top to the raw HTTPS Copy Link URL, without Markdown brackets.'
[[ $url == *token=* && $url == *signature=* ]] || fail 'The URL is missing its token or signature.'
case "$SKIP_OS_CHECK" in auto|yes|no) ;; *) fail 'SKIP_OS_CHECK must be auto, yes, or no.' ;; esac

if (( EUID != 0 )); then
    command -v sudo >/dev/null || fail 'sudo is unavailable. Run this script as root using bash.'
    printf 'Administrator access is required.\n'
    exec sudo -- bash "$0" "$@"
fi
command -v systemctl >/dev/null || fail 'This installer requires systemd.'
[[ -d /run/systemd/system ]] || fail 'systemd is not running on this computer.'

# Install only the download prerequisites; Syncro handles agent dependencies.
if ! command -v curl >/dev/null || [[ ! -s /etc/ssl/certs/ca-certificates.crt && ! -s /etc/pki/tls/certs/ca-bundle.crt ]]; then
    printf 'Installing curl and trusted CA certificates...\n'
    if command -v apt-get >/dev/null; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y curl ca-certificates
    elif command -v dnf >/dev/null; then
        dnf install -y curl ca-certificates
    elif command -v yum >/dev/null; then
        yum install -y curl ca-certificates
    else
        fail 'Install curl and ca-certificates, then run this script again.'
    fi
fi

installer_args=()
if [[ $SKIP_OS_CHECK == yes ]]; then
    installer_args+=(--skip-os-check)
elif [[ $SKIP_OS_CHECK == auto ]]; then
    [[ -r /etc/os-release ]] || fail 'Cannot identify the distribution. Set SKIP_OS_CHECK explicitly.'
    # Standard local distribution metadata.
    . /etc/os-release
    case "${ID:-}" in
        ubuntu|rhel) ;;
        debian|zorin|linuxmint|pop|rocky|almalinux|centos|fedora)
            installer_args+=(--skip-os-check) ;;
        *)
            case " ${ID_LIKE:-} " in
                *' debian '*|*' ubuntu '*|*' rhel '*|*' fedora '*) installer_args+=(--skip-os-check) ;;
            esac ;;
    esac
fi

# Use local storage, not the USB. Preserve Syncro's server-supplied filename.
work_dir=$(mktemp -d /var/tmp/syncro-install.XXXXXXXX)
trap 'rm -rf -- "$work_dir"' EXIT
cd -- "$work_dir"
printf 'Downloading Syncro Linux %s installer...\n' "$agent_arch"
if ! curl --fail --silent --show-error --location --remote-name --remote-header-name \
    --globoff --proto '=https' --proto-redir '=https' \
    --connect-timeout 30 --max-time 900 -- "$url"; then
    fail 'Download failed. Check internet access and generate a fresh Syncro link (valid for 7 days).'
fi

shopt -s nullglob
installers=(SyncroInstallerLinux-*.run)
(( ${#installers[@]} == 1 )) ||
    fail 'No unique Syncro .run installer received. Generate a fresh Copy Link; a login/error page may have been returned.'
installer=${installers[0]}
[[ -f $installer && ! -L $installer && -s $installer ]] || fail 'The downloaded installer is empty or invalid.'
[[ $installer == "SyncroInstallerLinux-${agent_arch}-"*.run ]] ||
    fail "The link is for a different architecture. Copy the Linux $agent_arch link from Syncro."
# Reject common HTTP 200 error pages. Never execute those as root.
if head -c 1024 -- "$installer" | LC_ALL=C grep -aEiq '<!doctype[[:space:]]+html|<html([[:space:]>])'; then
    fail 'Syncro returned an HTML page instead of an installer. Refresh the link.'
fi
chmod 700 -- "$installer"
if (( ${#installer_args[@]} )); then
    printf 'Using --skip-os-check for this distribution.\n'
fi
printf 'Running %s...\n' "$installer"
if "./$installer" "${installer_args[@]}"; then
    printf 'Installer finished. Checking the syncro service...\n'
else
    installer_rc=$?
    fail "Installer exited with code $installer_rc. Review its output. If execution was denied, check /var/tmp mount options. On derivatives, .NET 8 may require manual installation."
fi

for (( attempt=0; attempt<15; attempt++ )); do
    if systemctl is-active --quiet syncro; then
        printf '\nSUCCESS: The Syncro service is active. Confirm the asset appears under the intended customer/policy in Syncro.\n'
        exit 0
    fi
    sleep 2
done
systemctl --no-pager --full status syncro || true
fail 'The installer finished, but syncro is not active. Review: sudo journalctl -u syncro -n 80 --no-pager'
