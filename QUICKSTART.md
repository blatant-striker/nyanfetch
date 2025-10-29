# Quick Start - Publishing Your Package

## 🚀 Automated Setup (Recommended)

Your package now has GitHub Actions configured to automatically build and release!

### Step 1: Create GitHub Repository

```bash
# Install GitHub CLI (if not installed)
sudo apt install gh

# Login to GitHub
gh auth login

# Create repository and push
cd /home/blatantstriker/CascadeProjects/nyancat-neofetch
git add .
git commit -m "Initial release: nyancat-neofetch v1.0.0"
gh repo create nyancat-neofetch --public --source=. --push
```

### Step 2: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** → **Pages**
3. Under "Build and deployment":
   - Source: **GitHub Actions**
4. Save

### Step 3: Create Your First Release

```bash
# Create and push a version tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

This will automatically:
- ✅ Build the Debian package
- ✅ Create a GitHub Release with the `.deb` file
- ✅ Update your APT repository on GitHub Pages

### Step 4: Users Can Now Install!

**Option A: Direct Installation**
```bash
# Download from releases page
wget https://github.com/YOUR_USERNAME/nyancat-neofetch/releases/download/v1.0.0/nyancat-neofetch_1.0.0-1_all.deb
sudo dpkg -i nyancat-neofetch_1.0.0-1_all.deb
```

**Option B: APT Repository** (After gh-pages is set up)
```bash
echo "deb [trusted=yes] https://YOUR_USERNAME.github.io/nyancat-neofetch stable main" | \
  sudo tee /etc/apt/sources.list.d/nyancat-neofetch.list

sudo apt update
sudo apt install nyancat-neofetch
```

---

## 📦 Manual Publishing (Alternative)

If you prefer manual control:

### GitHub Releases Only

```bash
# Build the package
dpkg-buildpackage -us -uc -b

# Install GitHub CLI and create release
gh release create v1.0.0 ../nyancat-neofetch_1.0.0-1_all.deb \
  --title "nyancat-neofetch v1.0.0" \
  --notes "Animated Nyan Cat system info display"
```

---

## 🔄 Updating Your Package

1. Make your changes
2. Update version in `debian/changelog`
3. Commit changes
4. Create new tag:
   ```bash
   git tag -a v1.0.1 -m "Release version 1.0.1"
   git push origin v1.0.1
   ```
5. GitHub Actions will automatically build and release!

---

## ⚙️ What's Configured

### Automatic Workflows

1. **release.yml** - Triggers on version tags (v*)
   - Builds Debian package
   - Creates GitHub Release
   - Uploads .deb file

2. **build-repo.yml** - Updates APT repository
   - Creates proper APT repository structure
   - Publishes to GitHub Pages
   - Users can use `apt install`

### Manual Trigger

You can also manually trigger builds:
1. Go to **Actions** tab on GitHub
2. Select workflow
3. Click **Run workflow**

---

## 🎯 Next Steps

1. Update `debian/control` with your name/email
2. Update `debian/changelog` with your info
3. Create GitHub repository
4. Push and tag v1.0.0
5. Watch the magic happen in GitHub Actions!

---

## 📚 Additional Resources

- Full publishing options: See `PUBLISH.md`
- Build instructions: See `BUILD.md`
- Usage: See `README.md`

---

## 🐛 Troubleshooting

**GitHub Actions failing?**
- Check Actions tab for error logs
- Ensure GitHub Pages is enabled
- For gh-pages branch, it will be created automatically on first release

**Users can't install from APT?**
- Ensure GitHub Pages is published
- Check repository URL is correct
- Note: First build might take a few minutes

**Want signed packages?**
- Add GPG key to GitHub Secrets
- Update workflow to sign packages
- See `PUBLISH.md` for details
