# isaacangello

Stack: Vite 5, Alpine.js 3, Tailwind CSS 4, Animate.css

## Commands
- `npm run dev` — dev server
- `npm run build` — production build (output: public_html/)
- `npm run preview` — preview production build

## Scripts
- `./scripts/new-post.sh "Title"` — create new blog post
- `./scripts/generate-index.js` — regenerate blog index.json
- `./scripts/deploy.sh` — manual FTP deploy

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
