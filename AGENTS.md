# isaacangello

Stack: Vite 5, Alpine.js 3, Tailwind CSS 4, Animate.css

## Commands
- `npm run dev` — dev server
- `npm run build` — production build (output: public_html/)
- `npm run preview` — preview production build

## Scripts
- `./scripts/new-post.sh "Title" [--prefix <code>]` — create new blog post (markdown-maverik new); asks for prefix interactively if omitted, validates `--prefix` against config
- `./scripts/new-post.sh prefixes` — list configured prefixes
- `./scripts/new-post.sh build` — regenerate blog index.json (same as `npm run post:build`)
- `npm run post:build` — regenerate blog index.json (markdown-maverik build)
- `npm run post:new "Title"` — npm shortcut to create a new post
- `./scripts/deploy.sh [infinityfree|50webs|all]` — manual FTP deploy (default: infinityfree)

## Blog engine
- Powered by `markdown-maverik` (npm) — config in `markdown-maverik.config.js`
- CLI: `markdown-maverik build` / `markdown-maverik new "Title" --prefix <code>` / `markdown-maverik prefixes`
- Build runs automatically in `npm run build` (vite plugin `generate-blog-index`)

## Router
- Powered by `router-maverik` (npm) — History API, clean indexable URLs (no hash)
- Setup in `main.js`: `createRouter` + `installAlpine(Alpine, 'router', router)`
- Server rewrites unknown paths to `index.html` via `public/.htaccess`
- Legacy `#/route` links are auto-converted by `router.start()` (client-side)

## Branches
- `main` — production (auto-deploy via GitHub Actions on push)
- `develop` — local development only (no remote tracking)

## SPA Routes
- `/` — home (default)
- `/blog` — blog listing
- `/blog/:slug` — individual post
- `/curriculo` — resume
- `/projetos` — projects
- `/contato` — contact

## GitHub Secrets (deploy)
- `INFINITY_FREE_HOST`, `INFINITY_FREE_USER`, `INFINITY_FREE_PASSWORD` — InfinityFree
- `FTP_HOST`, `FTP_USERNAME`, `FTP_PASSWORD` — 50webs
