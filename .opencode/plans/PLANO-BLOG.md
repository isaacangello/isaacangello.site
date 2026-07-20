# Plano: Blog Pessoal — Isaac Castro Dev

## Objetivo

Criar um blog pessoal estático inspirado no [AkitaOnRails](https://github.com/akitaonrails/akitaonrails.github.io) (Hugo + Markdown + Netlify), adaptado para a stack do projeto (Vite + Alpine.js + Tailwind CSS).

## Arquitetura

```
src/
├── posts/                      # Posts em Markdown com frontmatter
│   ├── index.json              # Índice auto-gerado pelo script de build
│   └── 2025-01-15-hello.md     # Post individual
├── html/
│   ├── blog.html               # Listagem de posts (router /#/blog)
│   └── post.html               # Template de post individual
scripts/
├── new-post.sh                 # Cria novo post via CLI
└── generate-index.js           # Gera index.json a partir dos .md
vite.config.js                  # Integração com build via plugin copy-html-pages
```

## Formato do Post

```markdown
---
title: "Meu Primeiro Post"
date: 2025-01-15
tags: [laravel, php]
description: "Descrição curta do post"
---

Conteúdo em **Markdown** aqui...
```

## Fluxo de Trabalho

1. **`./scripts/new-post.sh "Título do Post"`** → cria `.md` com frontmatter + abre no editor
2. **`./scripts/generate-index.js`** (ou integrado ao `npm run build`) → lê todos `.md`, extrai frontmatter, converte body pra HTML com `marked`, gera `index.json`
3. **`npm run build`** → Vite build + plugin copia `src/posts/` para `public_html/posts/`
4. **Runtime** → Alpine store `blog` carrega `index.json`, renderiza lista de posts. Ao clicar, exibe o post pré-renderizado.

## Dependências

- `marked` (Node.js) — usado apenas no script de build (~0KB no bundle final)

## Rotas

| URL | Página |
|-----|--------|
| `/#/blog` | Lista cronológica agrupada por mês/ano |
| `/#/blog/titulo-do-post` | Post individual |

## UI (esboço)

- **Lista**: Cards com data, título, tags, descrição — agrupados por mês/ano
- **Post individual**: Título + data + tags no topo, conteúdo HTML abaixo
- **Navbar**: Link "Blog" entre "Home" e "Currículo"

## Diferenças para o AkitaOnRails

| Funcionalidade | AkitaOnRails (Hugo) | Isaac Castro (Vite + Alpine) |
|---------------|---------------------|------------------------------|
| Gerador | Hugo (Go) | Vite build + JSON |
| Renderização | Servidor (HTML pronto) | Cliente (Alpine lê JSON) |
| Index | Ruby script | Node.js script |
| Categorias | Akitando, Off-Topic | Tags apenas (mais simples) |
| Deploy | Netlify | InfinityFree via FTP |

## Status

- [x] `npm install marked --save-dev`
- [x] `scripts/new-post.sh`
- [x] `scripts/generate-index.js`
- [x] `src/posts/index.json` (gerado pelo script)
- [x] `src/posts/exemplo.md` (post de exemplo)
- [x] `src/html/blog.html` (listagem)
- [x] `src/html/post.html` (template de post)
- [x] Adicionar rota `/blog` e `/blog/:slug` no router
- [x] Adicionar link "Blog" na navbar
- [x] Plugin Vite copia `src/posts/` para `public_html/posts/`
- [x] Build + testar
