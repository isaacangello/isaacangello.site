# isaacangello

Stack: Vite 5, Alpine.js 3, Tailwind CSS 4, Animate.css

## Commands
- `npm run dev` — dev server
- `npm run build` — production build (output: public_html/)
- `npm run preview` — preview production build

## Scripts
- `./scripts/new-post.sh "Title"` — create new blog post (markdown-maverik new)
- `npm run post:build` — regenerate blog index.json (markdown-maverik build)
- `npm run post:new "Title"` — npm shortcut to create a new post
- `./scripts/deploy.sh` — manual FTP deploy

## Blog engine
- Powered by `markdown-maverik` (npm) — config in `markdown-maverik.config.js`
- CLI: `markdown-maverik build` / `markdown-maverik new "Title" --prefix <code>` / `markdown-maverik prefixes`
- Build runs automatically in `npm run build` (vite plugin `generate-blog-index`)

## Branches
- `main` — production (auto-deploy via GitHub Actions on push)
- `develop` — local development only (no remote tracking)

## SPA Routes
- `/#/home` — home (default)
- `/#/blog` — blog listing
- `/#/blog/:slug` — individual post
- `/#/curriculo` — resume
- `/#/projetos` — projects
- `/#/contato` — contact

## GitHub Secrets (deploy)
- `INFINITY_FREE_HOST`, `INFINITY_FREE_USER`, `INFINITY_FREE_PASSWORD`
