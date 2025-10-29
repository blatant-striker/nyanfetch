# Building and Packaging Guide

## Quick Build Instructions

### 1. Install Build Dependencies

```bash
sudo apt install debhelper build-essential devscripts
```

### 2. Build the Debian Package

From the project root directory:

```bash
dpkg-buildpackage -us -uc -b
```

This will create the `.deb` package file in the parent directory.

### 3. Install the Package

```bash
sudo dpkg -i ../nyancat-neofetch_1.0.0-1_all.deb
```

### 4. Fix Missing Dependencies (if needed)

```bash
sudo apt install -f
```

## Testing the Package

After installation, test by running:
```bash
nyanfetch
```

## Creating a Signed Package

For distribution, you should sign your package:

1. Generate a GPG key (if you don't have one):
```bash
gpg --full-generate-key
```

2. Build and sign:
```bash
dpkg-buildpackage -b
```

## Publishing to Your Own Repository

### Using `aptly`

1. Install aptly:
```bash
sudo apt install aptly
```

2. Create repository:
```bash
aptly repo create nyancat-repo
```

3. Add your package:
```bash
aptly repo add nyancat-repo ../nyancat-neofetch_1.0.0-1_all.deb
```

4. Publish:
```bash
aptly publish repo nyancat-repo
```

### Using GitHub as APT Repository

You can host a simple APT repository on GitHub Pages. See popular tools like:
- `deb-s3`
- `aptly` with S3
- Custom scripts with GitHub Actions

## Before You Customize

Edit these files with your information:

1. **debian/control** - Update maintainer name and email
2. **debian/changelog** - Update author info
3. **debian/copyright** - Update copyright holder
4. **README.md** - Update repository URLs

## Common Issues

### Permission Errors
Make sure `debian/rules` is executable:
```bash
chmod +x debian/rules
```

### Missing Standards Version
If you get warnings about standards version, update `debian/control`:
```
Standards-Version: 4.6.2
```

### Lintian Warnings
Check package quality:
```bash
lintian ../nyancat-neofetch_1.0.0-1_all.deb
```
