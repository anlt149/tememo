import type { APIRoute } from 'astro';
import { getCollection } from 'astro:content';
import fs from 'node:fs';
import path from 'node:path';

export async function getStaticPaths() {
	const posts = await getCollection('blog');
	return posts.map((post) => ({
		params: { slug: post.id },
		props: post,
	}));
}

export const GET: APIRoute = async ({ props }) => {
	const post = props;
	let content = "";
	
	// Try to get body directly if available (Astro v2/v3 style)
	if (post.body) {
		content = post.body;
	} else {
		// Read from file system for Astro v4/v5 loaders
		const baseDir = path.join(process.cwd(), 'src/content/blog');
		const mdPath = path.join(baseDir, `${post.id}.md`);
		const mdxPath = path.join(baseDir, `${post.id}.mdx`);
		
		try {
			content = fs.readFileSync(mdPath, 'utf-8');
		} catch (e) {
			try {
				content = fs.readFileSync(mdxPath, 'utf-8');
			} catch (e2) {
				content = "Error: Could not read markdown file.";
			}
		}
	}
	
	return new Response(content, {
		headers: {
			'Content-Type': 'text/markdown',
			'Content-Disposition': `attachment; filename="${post.id}.md"`
		},
	});
};
