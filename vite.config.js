import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'
import { copyFileSync, mkdirSync, readdirSync, statSync, existsSync, unlinkSync } from 'fs'
import { join, resolve } from 'path'
import { execSync } from 'child_process'

function copyDir(src, dest) {
  if (!existsSync(dest)) mkdirSync(dest, { recursive: true })
  for (const entry of readdirSync(src)) {
    const srcPath = join(src, entry)
    const destPath = join(dest, entry)
    if (statSync(srcPath).isDirectory()) {
      copyDir(srcPath, destPath)
    } else {
      copyFileSync(srcPath, destPath)
    }
  }
}

export default defineConfig({
  plugins: [
    tailwindcss(),
    {
      name: 'copy-html-pages',
      closeBundle() {
        const outDir = resolve(__dirname, 'public_html')

        copyDir(resolve(__dirname, 'src/html'), join(outDir, 'src/html'))
        copyDir(resolve(__dirname, 'src/img'), join(outDir, 'src/img'))

        const postsDest = join(outDir, 'src', 'posts')
        copyDir(resolve(__dirname, 'src/posts'), postsDest)
        for (const f of readdirSync(postsDest)) {
          if (f.endsWith('.md')) {
            unlinkSync(join(postsDest, f))
          }
        }
      }
    },
    {
      name: 'generate-blog-index',
      buildStart() {
        try {
          execSync('npx --no-install markdown-maverik build', { stdio: 'inherit' })
        } catch (e) {
          console.warn('markdown-maverik build falhou (rode npm install antes)')
        }
      }
    }
  ],
  base: './',
  build: {
    outDir:'public_html',
    chunkSizeWarningLimit: 1024
  }
})
