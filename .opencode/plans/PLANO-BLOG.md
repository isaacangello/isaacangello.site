# Plano: Blog Pessoal — Isaac Castro Dev

## Objetivo

Criar um blog pessoal estático inspirado no [AkitaOnRails](https://github.com/akitaonrails/akitaonrails.github.io) (Hugo + Markdown + Netlify), adaptado para a stack do projeto (Vite + Alpine.js + Tailwind CSS).

## Arquitetura

```
src/
├── posts/                      # Posts em Markdown com frontmatter
│   ├── index.json              # Índice gerado pelo markdown-maverik
│   └── 2025-01-15-hello.md     # Post individual
├── html/
│   ├── blog.html               # Listagem de posts (rota /blog)
│   └── post.html               # Template de post individual (rota /blog/:slug)
markdown-maverik.config.js      # Config do motor de blog (dir, out, marcadores)
scripts/
├── new-post.sh                 # Wrapper do markdown-maverik new
└── deploy.sh                   # Deploy manual via lftp
vite.config.js                  # Build + plugin copy-html-pages + gera index.json
```

## Formato do Post

```markdown
---
title: "Meu Primeiro Post"
date: 2025-01-15
tags: [laravel, php]
description: "Descrição curta do post"
prefix: tec
---

Conteúdo em **Markdown** aqui...
```

## Fluxo de Trabalho

1. **`./scripts/new-post.sh "Título do Post"`** → cria `.md` com frontmatter + abre no editor
2. **`npm run build`** (plugin vite `generate-blog-index`) → roda `markdown-maverik build`, que lê todos `.md`, extrai frontmatter, converte body pra HTML com GFM e gera `index.json`
3. **Build** → Vite build + plugin copia `src/html/`, `src/img/` e `src/posts/` para `public_html/`
4. **Runtime** → `router-maverik` resolve a rota e o Alpine carrega o `index.json`, renderiza lista de posts. Ao clicar, exibe o post pré-renderizado.

## Dependências

- `markdown-maverik` (npm) — motor de blog: gera `index.json` a partir dos `.md`
- `router-maverik` (npm) — roteamento History API com URLs limpas (sem hash)

## Rotas

| URL | Página |
|-----|--------|
| `/blog` | Lista cronológica de posts |
| `/blog/:slug` | Post individual |

## UI (esboço)

- **Lista**: Cards com data, título, tags, descrição — agrupados por mês/ano
- **Post individual**: Título + data + tags no topo, conteúdo HTML abaixo
- **Navbar**: Link "Blog" entre "Home" e "Currículo"

## Diferenças para o AkitaOnRails

| Funcionalidade | AkitaOnRails (Hugo) | Isaac Castro (Vite + Alpine) |
|---------------|---------------------|------------------------------|
| Gerador | Hugo (Go) | Vite build + JSON |
| Renderização | Servidor (HTML pronto) | Cliente (router-maverik + Alpine lê JSON) |
| Index | Ruby script | markdown-maverik (npm) |
| Categorias | Akitando, Off-Topic | Prefixos (tec, pol, dev, rel, others) |
| Deploy | Netlify | InfinityFree via FTP |
| URLs | Sem hash | Limpas e indexáveis (History API) |

## Status

- [x] `npm install marked --save-dev`
- [x] `scripts/new-post.sh`
- [x] `scripts/generate-index.js` (removido — substituído pelo `markdown-maverik`)
- [x] `src/posts/index.json` (gerado pelo `markdown-maverik build`)
- [x] `src/posts/exemplo.md` (post de exemplo)
- [x] `src/html/blog.html` (listagem)
- [x] `src/html/post.html` (template de post)
- [x] Motor de blog extraído para o pacote `markdown-maverik`
- [x] Adicionar rota `/blog` e `/blog/:slug` no router
- [x] Adicionar link "Blog" na navbar
- [x] Plugin Vite copia `src/posts/` para `public_html/posts/`
- [x] Navegação migrada para `router-maverik` (URLs limpas, sem hash)
- [x] Meta dinâmica por rota (title, description, OG, canonical)
- [x] `.htaccess` com rewrite de rotas para `index.html`
- [x] Build + testar
