#!/bin/bash

# Find staged markdown files in the blog directory
STAGED_POSTS=$(git diff --cached --name-only --diff-filter=ACM | grep '^src/content/blog/.*\.mdx\?$')

if [ -z "$STAGED_POSTS" ]; then
  exit 0
fi

echo "Verifying new or modified blog posts..."

FAILED=0

for file in $STAGED_POSTS; do
  echo "Checking $file..."

  # Check frontmatter keys
  if ! grep -q "^title:" "$file"; then
    echo "  ❌ Missing 'title' in frontmatter"
    FAILED=1
  fi

  if ! grep -q "^description:" "$file"; then
    echo "  ❌ Missing 'description' in frontmatter"
    FAILED=1
  fi

  if ! grep -q "^pubDate:" "$file"; then
    echo "  ❌ Missing 'pubDate' in frontmatter"
    FAILED=1
  fi

  if ! grep -q "^tags:" "$file"; then
    echo "  ❌ Missing 'tags' in frontmatter. Please add tags."
    FAILED=1
  fi

  # Check word count (excluding frontmatter)
  WORD_COUNT=$(awk 'BEGIN {in_fm=0; dash=0} /^---$/ {dash++; if (dash==1) in_fm=1; else if (dash==2) in_fm=0; next} {if (!in_fm) print}' "$file" | wc -w)
  
  if [ "$WORD_COUNT" -lt 50 ]; then
    echo "  ❌ Blog post is too short. Please write at least 50 words to provide enough information. (Current word count: $WORD_COUNT)"
    FAILED=1
  fi
done

if [ "$FAILED" -eq 1 ]; then
  echo ""
  echo "Validation failed! Please fix the errors above and try committing again."
  exit 1
fi

echo "All blog posts passed verification."
exit 0
