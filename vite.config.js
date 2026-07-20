import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'
import { copyFileSync, mkdirSync, readdirSync, statSync, existsSync } from 'fs'
import { join, resolve } from 'path'

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
      }
    }
  ],
  base: './',
  build: {
    outDir:'public_html',
    chunkSizeWarningLimit: 1024
  }
})
