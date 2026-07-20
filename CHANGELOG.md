# Changelog

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
