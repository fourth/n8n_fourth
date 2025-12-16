#!/bin/bash
set -e

echo "════════════════════════════════════════════════════════"
echo "  Fourth Intelligence Studio - Docker Image Tagging"
echo "════════════════════════════════════════════════════════"
echo ""

# Check if source images exist
if ! docker image inspect n8nio/n8n:local >/dev/null 2>&1; then
    echo "❌ Error: n8nio/n8n:local image not found"
    echo "   Run 'pnpm build:docker' first to build the images"
    exit 1
fi

if ! docker image inspect n8nio/runners:local >/dev/null 2>&1; then
    echo "❌ Error: n8nio/runners:local image not found"
    echo "   Run 'pnpm build:docker' first to build the images"
    exit 1
fi

echo "✓ Source images found"
echo ""

# Tag with Fourth branding
echo "📦 Tagging fourth/intelligence-studio:local..."
docker tag n8nio/n8n:local fourth/intelligence-studio:local

echo "📦 Tagging fourth/studio-runners:local..."
docker tag n8nio/runners:local fourth/studio-runners:local

echo ""
echo "════════════════════════════════════════════════════════"
echo "  ✅ Fourth Intelligence Studio Images Tagged"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Images available:"
docker images | grep -E "(REPOSITORY|fourth/)" | head -3
echo ""
echo "Next steps:"
echo "  1. Test locally: docker-compose -f docker-compose.fourth.yml up -d"
echo "  2. Access at: http://localhost:5680"
echo ""

