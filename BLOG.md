# Blog — Isaac Castro Dev

## Como criar um post

```bash
./scripts/new-post.sh "Título do Post"
```

Isso cria um arquivo em `src/posts/` com o formato:

```
src/posts/2026-07-20-titulo-do-post.md
```

O nome do arquivo é gerado automaticamente:
- Prefixo com a data (`YYYY-MM-DD`) para ordenação cronológica
- Slug derivado do título (lowercase, hífens, sem acentos)

Você pode renomear o arquivo depois se quiser um slug diferente. Ex: `2026-07-20-como-fiz-o-blog.md`.

## Frontmatter

Todo post começa com frontmatter no formato YAML entre `---`:

```markdown
---
title: "Meu Post"
date: 2026-07-20
tags: [laravel, php, alpinejs]
description: "Descrição curta que aparece na listagem"
---

Conteúdo do post em **Markdown**...
```

### Campos

| Campo | Obrigatório | Descrição |
|-------|-------------|-----------|
| `title` | Sim | Título do post |
| `date` | Sim | Data no formato `YYYY-MM-DD` |
| `tags` | Não | Lista de tags (array) |
| `description` | Não | Resumo exibido nos cards da listagem |

## Como funciona

1. **Build**: ao rodar `npm run build`, o script `scripts/generate-index.js` lê todos `.md` de `src/posts/`, converte o body para HTML com `marked`, extrai o frontmatter e gera `src/posts/index.json`
2. **Runtime**: o Alpine.js carrega o `index.json` e renderiza a listagem (`/#/blog`) ou o post individual (`/#/blog/:slug`)
3. **Slug**: extraído do nome do arquivo removendo o prefixo de data e a extensão `.md`

Exemplo: `2026-07-20-hello-world.md` → slug: `hello-world`

## Rotas

| URL | Página |
|-----|--------|
| `/#/blog` | Lista cronológica de posts |
| `/#/blog/:slug` | Post individual |
