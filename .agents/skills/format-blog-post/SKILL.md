---
name: format-blog-post
description: Update a newly added blog post to have the correct frontmatter format and formatting.
---

# Instructions

When the user asks you to format or update a newly added blog post, you should perform the following actions:

1.  **Check Frontmatter:** Ensure the blog post markdown file in `src/content/blog/` has the correct YAML frontmatter. The frontmatter MUST include:
    *   `title` (string)
    *   `description` (string)
    *   `pubDate` (string, e.g., 'Jun 26 2026')
    *   `heroImage` (string, optional, e.g., '../../assets/blog-placeholder-1.jpg')
    *   `tags` (array of strings)

    Example frontmatter:
    ```yaml
    ---
    title: 'Payment Orchestration: A Look at Our Tech Stack'
    description: 'An overview of the technologies powering our banking payment orchestration platform.'
    pubDate: 'Jun 26 2026'
    heroImage: '../../assets/blog-placeholder-1.jpg'
    tags: ['architecture', 'kafka', 'aws']
    ---
    ```

2.  **Format with Prettier:** Run the following command to format the blog post file using Prettier:
    `npx --yes prettier --write <path-to-blog-post.md>`

3.  **Review:** Ensure the file meets the project standards before confirming completion.
