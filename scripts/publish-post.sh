#!/bin/bash

# Publish a blog post by staging, verifying, committing, and pushing.

if [ -z "$1" ]; then
  echo "Usage: ./scripts/publish-post.sh <path-to-blog-post>"
  echo "Example: ./scripts/publish-post.sh src/content/blog/my-new-post.md"
  exit 1
fi

FILE="$1"
if [[ "$FILE" != /* ]]; then
  FILE="$(pwd)/$FILE"
fi

if [ ! -f "$FILE" ]; then
  echo "Error: File $FILE does not exist."
  exit 1
fi

# Ensure we are in the root directory
cd "$(dirname "$0")/.." || exit 1

# Extract the title from the frontmatter for the commit message
TITLE=$(grep "^title:" "$FILE" | sed 's/^title: *//' | sed 's/^"//;s/"$//' | sed "s/^'//;s/'$//")

if [ -z "$TITLE" ]; then
  TITLE=$(basename "$FILE")
fi

echo "Publishing: $TITLE"

# Stage the file so the verify script can pick it up
git add "$FILE"

# Run the verification script
echo "Running verification..."
./scripts/verify-blog-post.sh

if [ $? -ne 0 ]; then
  echo "Verification failed. Unstaging $FILE..."
  git restore --staged "$FILE"
  exit 1
fi

echo "Verification passed. Committing..."
git commit -m "docs: publish post '$TITLE'"

echo "Pushing to remote..."
git push

echo "Successfully published '$TITLE'!"
