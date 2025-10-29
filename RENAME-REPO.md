# Renaming GitHub Repository to "nyanfetch"

## Current Status
✅ All files have been updated to use "nyanfetch" instead of "nyancat-neofetch"  
✅ Git remote URL updated to: `https://github.com/blatant-striker/nyanfetch.git`

## Rename the GitHub Repository

### Option 1: Using GitHub Web Interface (Easiest)

1. Go to: https://github.com/blatant-striker/nyancat-neofetch
2. Click **Settings** (tab at top)
3. Scroll down to **"Repository name"**
4. Change from `nyancat-neofetch` to `nyanfetch`
5. Click **Rename**

GitHub will automatically redirect the old URL to the new one!

### Option 2: Using GitHub CLI

```bash
gh repo rename nyanfetch --repo blatant-striker/nyancat-neofetch
```

## After Renaming

Push your changes:
```bash
cd /home/blatantstriker/CascadeProjects/nyancat-neofetch
git add -A
git commit -m "Rename project to nyanfetch"
git push origin main
```

## Rebuild the Package

Clean old builds and rebuild with new name:
```bash
# Clean old build artifacts
debian/rules clean 2>/dev/null || true

# Build new package
dpkg-buildpackage -us -uc -b

# Install
sudo dpkg -r nyancat-neofetch 2>/dev/null || true  # Remove old package
sudo dpkg -i ../nyanfetch_1.0.0-1_all.deb
```

## Test
```bash
nyanfetch
```

## Note
The old GitHub URL will automatically redirect to the new one, so existing users won't break!
