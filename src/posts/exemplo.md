---
title: "Como fiz este blog pessoal"
date: 2026-07-20
tags: [alpinejs, vite, tailwindcss, javascript]
description: "Relato de como construí este blog estático usando Vite, Alpine.js e Tailwind CSS, com posts em Markdown e build automatizado."
---

## Motivação

Eu precisava de um blog pessoal simples, sem backend, sem banco de dados, mas que fosse fácil de escrever e manter. A solução? Um blog estático com:

- **Vite** como bundler (já usado no site)
- **Alpine.js** para reatividade no cliente
- **Tailwind CSS** para estilização
- **Markdown** para os posts

## Como funciona

### Estrutura

```
src/
├── posts/              # Posts em Markdown
│   ├── index.json      # Índice gerado automaticamente
│   └── 2025-01-15-meu-post.md
├── html/
│   ├── blog.html       # Listagem de posts
│   └── post.html       # Template de post individual
scripts/
├── new-post.sh         # Script para criar novo post
└── generate-index.js   # Gera o index.json a partir dos .md
```

### Fluxo de escrita

1. Rodo `./scripts/new-post.sh "Título do Post"`
2. Escrevo o conteúdo em Markdown
3. Faço o build (`npm run build`)
4. O script `generate-index.js` converte tudo para JSON
5. O Alpine.js carrega o JSON e renderiza no navegador

### Roteamento

O router do Alpine.js foi estendido para entender duas novas rotas:

| Rota | Função |
|------|--------|
| `/#/blog` | Lista todos os posts |
| `/#/blog/:slug` | Exibe o post individual |

## Conclusão

Com poucas linhas de código, tenho um blog funcional, rápido e sem depender de serviços externos. O melhor de tudo: escrevo em Markdown e o build cuida do resto.
