# Publishing Guide - Making Your Package Available via APT

## Quick Comparison of Options

| Method | Difficulty | Best For | Users Can Install With |
|--------|-----------|----------|------------------------|
| GitHub Releases | ⭐ Easy | Direct downloads | Manual .deb download |
| GitHub Pages APT Repo | ⭐⭐ Medium | Small projects | `apt install` (custom repo) |
| Launchpad PPA | ⭐⭐⭐ Hard | Ubuntu users | `apt install` (official) |
| PackageCloud | ⭐ Easy | All distros | `apt install` (hosted) |

---

## Option 1: GitHub Releases (Easiest - Manual Install)

Users download `.deb` file directly, but don't get automatic updates.

### Steps:

1. **Create GitHub repository** (if not already done):
```bash
cd /home/blatantstriker/CascadeProjects/nyanfetch
git init
git add .
git commit -m "Initial commit: nyanfetch package"
gh repo create nyanfetch --public --source=. --push
```

2. **Create a release with the .deb file**:
```bash
# Tag your release
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# Create GitHub release and upload .deb
gh release create v1.0.0 ../nyanfetch_1.0.0-1_all.deb \
  --title "nyanfetch v1.0.0" \
  --notes "Initial release of nyanfetch"
```

3. **Users install with**:
```bash
wget https://github.com/USERNAME/nyanfetch/releases/download/v1.0.0/nyanfetch_1.0.0-1_all.deb
sudo dpkg -i nyanfetch_1.0.0-1_all.deb
```

---

## Option 2: GitHub Pages APT Repository (Recommended)

Create a real APT repository hosted on GitHub Pages. Users can use `apt install`!

### Prerequisites:
```bash
sudo apt install reprepro gnupg
```

### Steps:

1. **Generate GPG key for signing** (if you don't have one):
```bash
gpg --full-generate-key
# Choose: (1) RSA and RSA
# Key size: 4096
# Expiration: 0 (doesn't expire)
# Enter your name and email

# Export public key
gpg --armor --export YOUR_EMAIL > public.key
```

2. **Set up repository structure**:
```bash
cd /home/blatantstriker/CascadeProjects
mkdir nyanfetch-repo
cd nyanfetch-repo

# Create reprepro configuration
mkdir -p conf
cat > conf/distributions << 'EOF'
Origin: nyanfetch
Label: nyanfetch
Codename: stable
Architectures: amd64 all
Components: main
Description: Nyanfetch Repository
SignWith: YOUR_GPG_KEY_ID
EOF
```

3. **Add package to repository**:
```bash
reprepro includedeb stable /path/to/nyanfetch_1.0.0-1_all.deb
```

4. **Set up GitHub Pages**:
```bash
# Initialize git repo
git init
git add .
git commit -m "Initial APT repository"

# Create GitHub repo and push
gh repo create nyanfetch-repo --public --source=. --push

# Enable GitHub Pages (Settings > Pages > Deploy from branch: main)
```

5. **Users add your repository**:
```bash
# Add GPG key
wget -qO - https://USERNAME.github.io/nyanfetch-repo/public.key | sudo apt-key add -

# Add repository
echo "deb https://USERNAME.github.io/nyanfetch-repo stable main" | \
  sudo tee /etc/apt/sources.list.d/nyanfetch.list

# Install
sudo apt update
sudo apt install nyanfetch
```

---

## Option 3: Launchpad PPA (Official Ubuntu)

Best for Ubuntu users - integrates with official Ubuntu infrastructure.

### Prerequisites:
- Launchpad account: https://launchpad.net/
- GPG key registered with Launchpad
- SSH key registered with Launchpad

### Steps:

1. **Create PPA on Launchpad**:
   - Go to https://launchpad.net/~YOUR_USERNAME
   - Click "Create a new PPA"
   - Name it (e.g., "nyanfetch")

2. **Install required tools**:
```bash
sudo apt install dput devscripts
```

3. **Configure dput** (~/.dput.cf):
```ini
[ppa]
fqdn = ppa.launchpad.net
method = ftp
incoming = ~YOUR_USERNAME/ubuntu/nyanfetch/
login = anonymous
allow_unsigned_uploads = 0
```

4. **Build source package**:
```bash
cd /home/blatantstriker/CascadeProjects/nyanfetch
debuild -S -sa
```

5. **Upload to PPA**:
```bash
dput ppa ../nyanfetch_1.0.0-1_source.changes
```

6. **Users install with**:
```bash
sudo add-apt-repository ppa:YOUR_USERNAME/nyanfetch
sudo apt update
sudo apt install nyanfetch
```

---

## Option 4: PackageCloud (Hosted Service)

Easiest hosted solution - supports multiple distros.

### Steps:

1. **Sign up**: https://packagecloud.io/ (free tier available)

2. **Install packagecloud CLI**:
```bash
gem install package_cloud
```

3. **Upload package**:
```bash
package_cloud push USERNAME/nyanfetch/ubuntu/focal \
  /path/to/nyanfetch_1.0.0-1_all.deb
```

4. **Users add repository** (instructions provided by PackageCloud)

---

## Option 5: Self-Hosted Repository

Host on your own server or VPS.

### Steps:

1. **Set up web server** (nginx/apache)

2. **Use aptly or reprepro** to manage repository

3. **Sync repository files** to web server

4. **Configure DNS** for your domain

---

## Recommended Workflow for Small Projects

**For beginners**, I recommend:
1. Start with **GitHub Releases** (easiest)
2. Later migrate to **GitHub Pages APT repo** (real APT support)

**For serious distribution**:
- Use **Launchpad PPA** (Ubuntu)
- Or **PackageCloud** (multi-distro)

---

## Automated Publishing with GitHub Actions

Would you like me to set up automated builds that:
- Build .deb on every release tag
- Automatically upload to GitHub Releases
- Update APT repository automatically

Let me know which option you'd like to pursue!
