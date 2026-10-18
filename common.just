# Recipes shared by every package justfile (each one does `import '../common.just'`).
# They run inside the importing package's module, so module_directory() is the
# package directory.

package := file_name(module_directory())

# Package manager for _packages: Homebrew on macOS, dnf (Fedora) on Linux.
package_install := if os() == "macos" { "brew install" } else { "sudo dnf install -y" }

# Symlink this package's files into $HOME
link: (_packages "stow:stow")
    stow --no-folding --dir=.. --target="$HOME" --ignore=justfile {{ package }}

# Remove this package's symlinks from $HOME
unlink:
    stow --dir=.. --target="$HOME" --delete --ignore=justfile {{ package }}

# Install the package behind each missing command; pairs are command:package.
_packages +pairs:
    #!/usr/bin/env bash
    set -euo pipefail
    for pair in {{ pairs }}; do
        cmd=${pair%%:*} pkg=${pair#*:}
        if command -v "$cmd" >/dev/null 2>&1; then
            echo "$cmd already installed"
        else
            echo "$cmd not found. Installing $pkg..."
            {{ package_install }} "$pkg"
        fi
    done

# Install Homebrew casks that aren't installed yet.
[macos]
_casks +casks:
    #!/usr/bin/env bash
    set -euo pipefail
    for cask in {{ casks }}; do
        if brew list --cask "$cask" >/dev/null 2>&1; then
            echo "$cask already installed"
        else
            echo "Installing $cask..."
            brew install --cask "$cask"
        fi
    done

# pip-install a Python package unless its module can already be imported.
_python-module module pkg:
    #!/usr/bin/env bash
    set -euo pipefail
    if python3 -c "import {{ module }}" 2>/dev/null; then
        echo "{{ module }} already installed"
    else
        echo "Installing {{ pkg }} via pip..."
        pip3 install --user {{ quote(pkg) }}
    fi

# Append a line to a file unless the file already contains it.
_append-line file line description:
    #!/usr/bin/env bash
    set -euo pipefail
    file={{ quote(file) }} line={{ quote(line) }}
    if grep -qF -- "$line" "$file" 2>/dev/null; then
        echo "{{ description }} already configured in $file"
    else
        echo "Adding {{ description }} to $file..."
        printf '\n%s\n' "$line" >> "$file"
    fi

# Enable and start systemd user units.
[linux]
_systemd-units +units:
    #!/usr/bin/env bash
    set -euo pipefail
    # Pick up unit files that were just linked in.
    systemctl --user daemon-reload
    for unit in {{ units }}; do
        if systemctl --user is-enabled "$unit" >/dev/null 2>&1; then
            echo "$unit already enabled"
        else
            echo "Enabling $unit..."
            systemctl --user enable "$unit"
        fi
        if systemctl --user is-active "$unit" >/dev/null 2>&1; then
            echo "$unit already active"
        else
            echo "Starting $unit..."
            systemctl --user start "$unit"
        fi
    done

[macos]
_systemd-units +units:
    @echo "No systemd on macOS; skipping {{ units }}"
