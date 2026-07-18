import os
import re
import shutil
import datetime
import PyPDF2

SOURCE_DIR = "/Users/marshall/code/go-books/books"
PUBLIC_BOOKS_DIR = "/Users/marshall/code/tememo/public/books"
BLOG_DIR = "/Users/marshall/code/tememo/src/content/blog"

def slugify(text):
    text = text.lower()
    text = re.sub(r'[^a-z0-9]+', '-', text)
    return text.strip('-')

def clean_text(text):
    # Remove weird characters and excessive newlines
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

def main():
    os.makedirs(PUBLIC_BOOKS_DIR, exist_ok=True)
    os.makedirs(BLOG_DIR, exist_ok=True)

    today = datetime.datetime.now().strftime("%b %d %Y")

    files = [f for f in os.listdir(SOURCE_DIR) if f.endswith('.pdf')]
    
    for filename in files:
        filepath = os.path.join(SOURCE_DIR, filename)
        
        # Clean title (remove .pdf and some common suffixes)
        raw_title = filename[:-4]
        title = raw_title.replace('_', ' ')
        title = re.sub(r'\(.*?\)', '', title) # Remove things in parentheses like (Z-Library)
        title = title.strip()
        
        slug = slugify(title)
        if not slug:
            slug = "book-" + str(hash(filename))

        print(f"Processing: {title} ({slug})")

        # Copy PDF
        dest_pdf = os.path.join(PUBLIC_BOOKS_DIR, slug + '.pdf')
        shutil.copy2(filepath, dest_pdf)

        # Extract text
        summary_text = ""
        try:
            with open(filepath, 'rb') as f:
                reader = PyPDF2.PdfReader(f)
                num_pages = min(15, len(reader.pages))
                
                # Try to extract text from the first 15 pages to find a good chunk
                full_text = ""
                for i in range(num_pages):
                    page = reader.pages[i]
                    text = page.extract_text()
                    if text:
                        full_text += text + " "
                
                cleaned = clean_text(full_text)
                
                # Try to skip the table of contents and very sparse pages
                words = cleaned.split()
                if len(words) > 50:
                    # Take up to 200 words as summary
                    summary_text = " ".join(words[:200]) + "..."
                else:
                    summary_text = "No summary available for this book. Please download the PDF to read more."
                    
        except Exception as e:
            print(f"Error reading {filename}: {e}")
            summary_text = "Error extracting summary. Please download the PDF to read more."

        description = "A great Golang resource now available in our library."

        # Write markdown
        md_content = f"""---
title: '{title}'
description: '{description}'
pubDate: '{today}'
heroImage: '../../assets/blog-placeholder-2.jpg'
tags: ['golang', 'book', 'pdf']
---

Welcome to our library's new addition: **{title}**!

## Summary

> {summary_text}

## Download

[Download {title} (PDF)](/books/{slug}.pdf)
"""
        
        md_filepath = os.path.join(BLOG_DIR, slug + '.md')
        with open(md_filepath, 'w') as f:
            f.write(md_content)

    print("Finished converting books.")

if __name__ == "__main__":
    main()
