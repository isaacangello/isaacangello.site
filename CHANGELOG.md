# Changelog

## v0.3.0 (2026-08-07)

### Feat
- **Motor de blog extraído para pacote `markdown-maverik`:** A tecnologia de posts em Markdown foi isolada e publicada no npm — o `isaacangello` agora consome o pacote (`scripts/generate-index.js` removido, `scripts/new-post.sh` vira wrapper do CLI)
- **Config `markdown-maverik.config.js`:** `dir: src/posts`, `out: src/posts/index.json`, marcadores de categoria (tec, pol, dev, rel, others)
- **Scripts npm:** `post:build` (regenera o index.json) e `post:new` (cria post via CLI)
- **GFM no build:** tabelas, task lists, strikethrough, autolinks e filtro de HTML desautorizado (§6.11 do GFM)
- **Prefixos no `index.json`:** o post inaugural `tec:` agora tem `prefix: { code: 'tec', label: 'Tec', name: 'Tecnologia' }` resolvido automaticamente

### Chore
- **`marked` removido:** dependência direta substituída pelo `markdown-maverik`
- **Docs atualizadas:** README, BLOG.md e AGENTS.md refletem o novo motor

## v0.2.0 (2026-07-20)

### Feat
- **Blog pessoal:** Posts em Markdown com frontmatter, build converte para JSON via `marked`, Alpine.js renderiza no cliente
- **Rotas `/blog` e `/#/blog/:slug`:** Listagem de posts com cards + template individual
- **Navbar:** Link "Blog" adicionado entre Home e Currículo (desktop e mobile)
- **Deploy automático:** GitHub Actions dispara na branch `main` — build + FTP para InfinityFree
- **Deploy manual:** `scripts/deploy.sh` com lftp

### Chore
- **`marked` adicionado:** Dependência de build para converter Markdown em HTML
- **`dist/` removido:** Build antigo deletado (não versionado)
- **`.gitignore` atualizado:** `public_html/`, `.env.ftp`, `dist/` adicionados
- **Branch `develop` criada:** Apenas local, sem tracking remoto
- **AGENTS.md criado:** Instruções para ferramentas AI
- **Workflow GitHub atualizado:** `main.yml` substituído por `deploy.yml` com InfinityFree

## v0.1.1 (2026-07-19)

### Feat
- **Router Alpine.js:** Navegação hash-based (`/#/home`, `/#/curriculo`, etc.) — botão voltar/avançar do navegador funciona, links diretos funcionam
- **Link ativo na navbar:** Destaque automático da página atual com `text-amber-600 font-bold`
- **Projetos reordenados:** P4O em primeiro lugar (com link para produção), Oportunidade & Ajuda em segundo, CleanERP por último (descontinuado, sem link)
- **SVGs inline:** Twitter/X e LinkedIn substituídos por SVGs diretos no HTML (sem dependências)

### Chore
- **Font Awesome removido:** `src/fa6/` deletado (~centenas de MB de ícones PRO licenciados)
- **README atualizado:** Informações corretas sobre o projeto
- **Plano de blog salvo:** `.opencode/plans/PLANO-BLOG.md`

### Fix
- **Build:** HTML pages (`src/html/`) agora são copiadas para `public_html/` via plugin Vite customizado

## v0.1.0 (2025)

- Versão inicial com Vite + Alpine.js + Tailwind CSS
- SPA com carregamento de páginas via fetch
- Font Awesome 6 Pro para ícones
- Páginas: Home, Currículo, Projetos, Contato
