#!/bin/bash
set -e

echo "🚀 Nyancat Neofetch - GitHub Setup & Publishing"
echo "================================================"
echo

# Check if git is configured
if ! git config user.name > /dev/null 2>&1; then
    echo "📝 Git not configured. Let's set it up!"
    echo
    read -p "Enter your name: " name
    read -p "Enter your email: " email
    
    git config user.name "$name"
    git config user.email "$email"
    
    echo "✅ Git configured for this repository"
    echo
fi

# Commit if not already done
if ! git log > /dev/null 2>&1; then
    echo "📦 Creating initial commit..."
    git add -A
    git commit -m "Initial commit: nyancat-neofetch v1.0.0 with automated packaging"
    echo "✅ Initial commit created"
    echo
fi

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "⚠️  GitHub CLI not found"
    echo "Install it with: sudo apt install gh"
    echo
    echo "Or manually create the repository on GitHub and run:"
    echo "  git remote add origin https://github.com/YOUR_USERNAME/nyancat-neofetch.git"
    echo "  git push -u origin main"
    echo "  git tag -a v1.0.0 -m 'Release version 1.0.0'"
    echo "  git push origin v1.0.0"
    exit 1
fi

# Check if logged into GitHub
if ! gh auth status &> /dev/null; then
    echo "🔐 Logging into GitHub..."
    gh auth login
    echo
fi

# Get GitHub username
GH_USERNAME=$(gh api user -q .login)
echo "👤 GitHub Username: $GH_USERNAME"
echo

# Check if remote exists
if git remote | grep -q origin; then
    echo "✅ Git remote already configured"
    REPO_URL=$(git remote get-url origin)
    echo "   Repository: $REPO_URL"
else
    echo "📤 Creating GitHub repository..."
    
    # Create repository
    if gh repo create nyancat-neofetch --public --source=. --remote=origin; then
        echo "✅ Repository created: https://github.com/$GH_USERNAME/nyancat-neofetch"
    else
        echo "⚠️  Repository might already exist"
        read -p "Enter repository URL (or press Enter to skip): " repo_url
        if [ -n "$repo_url" ]; then
            git remote add origin "$repo_url"
        fi
    fi
fi

echo
echo "📤 Pushing to GitHub..."
git push -u origin main || echo "⚠️  Push failed - may need to force push or repository already exists"

echo
echo "🏷️  Creating release tag v1.0.0..."
if git tag | grep -q "v1.0.0"; then
    echo "   Tag v1.0.0 already exists"
else
    git tag -a v1.0.0 -m "Release version 1.0.0"
fi

git push origin v1.0.0 || echo "   Tag may already exist on remote"

echo
echo "✅ Setup Complete!"
echo
echo "📋 Next Steps:"
echo "1. Go to: https://github.com/$GH_USERNAME/nyancat-neofetch"
echo "2. Click Settings → Pages"
echo "3. Set source to 'GitHub Actions'"
echo "4. Wait for the Actions workflow to complete"
echo
echo "🎉 After Actions complete, users can install with:"
echo
echo "   Option A - Direct download:"
echo "   wget https://github.com/$GH_USERNAME/nyancat-neofetch/releases/download/v1.0.0/nyancat-neofetch_1.0.0-1_all.deb"
echo "   sudo dpkg -i nyancat-neofetch_1.0.0-1_all.deb"
echo
echo "   Option B - APT repository (after gh-pages is set up):"
echo "   echo \"deb [trusted=yes] https://$GH_USERNAME.github.io/nyancat-neofetch stable main\" | sudo tee /etc/apt/sources.list.d/nyancat-neofetch.list"
echo "   sudo apt update && sudo apt install nyancat-neofetch"
echo
echo "🔗 Monitor build progress:"
echo "   https://github.com/$GH_USERNAME/nyancat-neofetch/actions"
echo
