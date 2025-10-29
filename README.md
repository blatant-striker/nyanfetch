# Nyancat Neofetch

An animated Nyan Cat ASCII art system information display tool for Linux terminals.

## Features

- 🌈 Animated Nyan Cat ASCII art (5 frame animation)
- 💻 Real-time system information display
- 📊 CPU and memory usage bars with color-coded indicators
- 🎨 Colorful terminal output
- 🔄 Updates dynamic stats every 1.5 seconds

## System Information Displayed

- User@Hostname
- Operating System
- Kernel version
- Uptime
- Shell
- Package count
- Desktop Environment
- Window Manager
- CPU model and usage
- GPU information
- Memory usage
- Disk usage
- Screen resolution
- Color palette

## Installation

### From Source (Manual)

```bash
sudo make install
```

### Building Debian Package

1. Install build dependencies:
```bash
sudo apt install debhelper build-essential
```

2. Build the package:
```bash
dpkg-buildpackage -us -uc -b
```

3. Install the generated .deb package:
```bash
sudo dpkg -i ../nyancat-neofetch_1.0.0-1_all.deb
```

### From APT Repository (After publishing)

```bash
sudo apt install nyancat-neofetch
```

## Usage

Simply run:
```bash
nyanfetch
```

Press `Ctrl+C` to exit.

## Dependencies

**Required:**
- bash >= 4.0
- coreutils
- procps

**Optional (for full features):**
- lspci (for GPU information)
- x11-utils (for resolution detection)

## Uninstallation

If installed via APT:
```bash
sudo apt remove nyancat-neofetch
```

If installed manually:
```bash
sudo make uninstall
```

## Publishing to APT Repository

To make this available via `apt install`, you have several options:

### Option 1: Personal PPA (Ubuntu)

1. Create a Launchpad account
2. Set up your PPA
3. Upload the source package using `dput`

### Option 2: Custom APT Repository

1. Set up a web server or use GitHub Pages
2. Create repository structure with reprepro or aptly
3. Sign packages with GPG
4. Distribute repository configuration

### Option 3: Submit to Debian

1. Find a Debian sponsor
2. Follow Debian packaging guidelines
3. Submit to Debian mentors

## License

MIT License - See COPYRIGHT file for details

## Credits

Based on the original Nyancat ASCII art animation.
