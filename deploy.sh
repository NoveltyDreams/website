#!/bin/bash
# Deploy to Neocities
# Usage: ./deploy.sh

set -e

# Load API key from .env
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

API_KEY="${NEOCITIES_API_KEY}"

if [ -z "$API_KEY" ]; then
    echo "Error: NEOCITIES_API_KEY not set. Add it to .env file."
    exit 1
fi
PUBLIC_DIR="public"

echo "Building site..."
npx @11ty/eleventy

echo "Deploying to Neocities..."

# Upload all files from public directory
cd "$PUBLIC_DIR"

find . -type f | while read file; do
    # Remove leading ./
    filepath="${file#./}"
    echo "Uploading: $filepath"
    curl -s -H "Authorization: Bearer $API_KEY" \
         -F "$filepath=@$file" \
         "https://neocities.org/api/upload"
    echo ""
done

echo "Deploy complete!"
echo "View at: https://noveltydreams.neocities.org"
