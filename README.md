# Isaac Castro — Site Pessoal

Site pessoal / portfólio de [Isaac Castro](https://isaacangello.dev), desenvolvedor web fullstack.

## Stack

| Camada | Tecnologia |
|--------|-----------|
| Bundler | Vite 5 |
| Reatividade | Alpine.js 3 |
| Estilo | Tailwind CSS 4 |
| Animações | Animate.css |
| Ícones | SVGs inline |

## Estrutura

```
src/
├── html/           # Páginas HTML (carregadas via router)
├── css/            # Estilos + font-face + Tailwind
├── fonts/          # Fontes locais (Work Sans, DIN Next, Helvetica)
├── img/            # Imagens (screenshots de projetos, avatar)
└── posts/          # Posts do blog (Markdown)
scripts/            # Scripts CLI (new-post.sh, generate-index.js)
public_html/        # Build output (Vite)
```

## Rotas

| URL | Página |
|-----|--------|
| `/#/home` | Home (default) |
| `/#/curriculo` | Currículo |
| `/#/projetos` | Projetos |
| `/#/contato` | Contato |
| `/#/blog` | Blog (em desenvolvimento) |

## Desenvolvimento

```bash
npm run dev          # Servidor de desenvolvimento
npm run build        # Build para produção (saída em public_html/)
```

## Projetos em Destaque

- [P4O — Process 4 Order](https://p4o.free.nf) — Gestão de ordens de serviço
- [Oportunidade & Ajuda](https://oportunidadeeajuda.com/dev) — Portal para imigrantes brasileiros nos EUA

## Licença

MIT
