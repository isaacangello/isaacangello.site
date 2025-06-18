import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [tailwindcss()],
  base: './',  
  build: {
    outDir:'public_html',
    chunkSizeWarningLimit: 1024 // kB
  }
})
