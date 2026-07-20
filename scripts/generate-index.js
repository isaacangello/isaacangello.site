#!/usr/bin/env node
// generate-index.js — Lê src/posts/*.md, gera src/posts/index.json

import { readdirSync, readFileSync, writeFileSync, existsSync } from 'fs'
import { join, resolve } from 'path'
import { marked } from 'marked'

marked.use({ gfm: true, breaks: true })

const postsDir = resolve(process.argv[2] || 'src/posts')
const outFile = join(postsDir, 'index.json')

if (!existsSync(postsDir)) {
  console.error(`Diretório não encontrado: ${postsDir}`)
  process.exit(1)
}

const files = readdirSync(postsDir).filter(f => f.endsWith('.md'))
const posts = []

for (const file of files) {
  const raw = readFileSync(join(postsDir, file), 'utf-8')
  const match = raw.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/)
  if (!match) continue

  const fm = {}
  for (const line of match[1].split('\n')) {
    const sep = line.indexOf(':')
    if (sep === -1) continue
    const k = line.slice(0, sep).trim()
    let v = line.slice(sep + 1).trim()
    if (v.startsWith('[') && v.endsWith(']')) {
      v = v.slice(1, -1).split(',').map(s => s.trim().replace(/^['"]|['"]$/g, '')).filter(Boolean)
    } else {
      v = v.replace(/^"(.*)"$/, '$1').replace(/^'(.*)'$/, '$1')
    }
    fm[k] = v
  }

  const bodyHtml = marked.parse(match[2].trim(), { async: false })

  const slug = file.replace(/^\d{4}-\d{2}-\d{2}-/, '').replace(/\.md$/, '')

  posts.push({
    slug,
    file,
    title: fm.title || slug,
    date: fm.date || '',
    tags: Array.isArray(fm.tags) ? fm.tags : [],
    description: fm.description || '',
    body: bodyHtml
  })
}

posts.sort((a, b) => (a.date > b.date ? -1 : a.date < b.date ? 1 : 0))

writeFileSync(outFile, JSON.stringify(posts, null, 2), 'utf-8')
console.log(`Gerado: ${outFile} (${posts.length} posts)`)
