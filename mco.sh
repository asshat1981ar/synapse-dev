#!/usr/bin/env bash
set -euo pipefail

###
### User-configurable section
###
# Your GitHub user/org and repo name
GH_OWNER="asshat1981ar"
REPO_NAME="smithery-meta-mcp"

# Remote git URL
GIT_URL="git@github.com:${GH_OWNER}/${REPO_NAME}.git"

# Default branch
BRANCH="main"

# Smithery “install” client
SMITHERY_CLI="${SMITHERY_CLI:-npx @smithery/cli}"

# MCP client (e.g. claude)
MCP_CLIENT="${MCP_CLIENT:-claude}"

###
### Script starts here
###
echo "🚀 Starting deploy for ${REPO_NAME}"

# 1. Validate required env vars
: "${GITHUB_TOKEN:?Need to set GITHUB_TOKEN}"
: "${SMITHERY_CLI_TOKEN:?Need to set SMITHERY_CLI_TOKEN}"

# 2. Ensure project dir
if [ ! -f smithery.yaml ] || [ ! -d src ]; then
  echo "❌ This script must be run from the root of the meta-MCP project."
  exit 1
fi

# 3. Install deps & build
echo "📦 Installing dependencies..."
npm ci --omit=dev

echo "🛠️  Compiling TypeScript..."
npx tsc

# 4. Git: init & push (if not already)
if [ ! -d .git ]; then
  echo "🗂️  Initializing Git repo..."
  git init
  git branch -m $BRANCH
  git remote add origin "$GIT_URL"
fi

echo "📝 Committing & pushing to GitHub..."
git add .
git commit -m "chore: build and prepare release" || echo "(no changes to commit)"
git push -u origin $BRANCH --force

# 5. Publish to Smithery registry
echo "🌐 Publishing to Smithery.ai..."
$SMITHERY_CLI install "${GH_OWNER}/${REPO_NAME}" --client "$MCP_CLIENT" \
  --github-token "$GITHUB_TOKEN" \
  --smithery-token "$SMITHERY_CLI_TOKEN"

echo "✅ Done! Your MCP is live and installed in ${MCP_CLIENT}."
