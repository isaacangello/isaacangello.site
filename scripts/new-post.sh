#!/bin/bash
# new-post.sh — Interface para o markdown-maverik
#
# Uso:
#   ./scripts/new-post.sh "Título do Post" [--prefix <code>] [--dir <pasta>]
#   ./scripts/new-post.sh prefixes    # lista os prefixos configurados
#   ./scripts/new-post.sh build       # regenera o index.json do blog
#   ./scripts/new-post.sh remove [alvo] # remove post (lista se sem alvo) e
#                                      # regenera o index.json
#
# Opções repassadas ao 'markdown-maverik new':
#   --prefix <code>   Prefixo do post (ex.: tec, dev, pol, rel, others).
#                     Se omitido, o script pergunta interativamente.
#   --dir <pasta>     Pasta de destino dos posts (default: config.dir).
#
# O 'remove' aceita nome completo (2026-10-13-foo.md), sem extensão ou só o
# slug (foo); pede confirmação antes de apagar.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SCRIPT_DIR"

MM=(npx --no-install markdown-maverik)

usage() {
  cat <<'EOF'
Uso:
  ./scripts/new-post.sh "Título do Post" [--prefix <code>] [--dir <pasta>]
  ./scripts/new-post.sh prefixes      # lista os prefixos configurados
  ./scripts/new-post.sh build         # regenera o index.json do blog
  ./scripts/new-post.sh remove [alvo] # remove post e regenera o index.json
  ./scripts/new-post.sh --help        # mostra esta ajuda

Opções repassadas ao 'markdown-maverik new':
  --prefix <code>   Prefixo do post (ex.: tec, dev, pol, rel, others).
                    Se omitido, o script pergunta interativamente.
  --dir <pasta>     Pasta de destino dos posts (default: config.dir).

O 'remove' (alias 'rm') aceita nome completo (2026-10-13-foo.md), sem
extensão ou só o slug (foo) e pede confirmação antes de apagar; sem alvo,
lista os posts numerados para escolher.
EOF
}

# Códigos de prefixo válidos (primeira coluna de 'markdown-maverik prefixes')
valid_prefixes() {
  "${MM[@]}" prefixes | awk 'NR > 1 {print $1}'
}

# Pasta de posts lida do markdown-maverik.config.js (default ./posts)
posts_dir() {
  node -e 'import("./markdown-maverik.config.js")
    .then(m => process.stdout.write(String(m.default?.dir ?? "./posts")))
    .catch(() => process.stdout.write("./posts"))'
}

# Título do post a partir do frontmatter (se o alvo resolver direto)
post_title() {
  local dir="$1" target="$2" base="${2##*/}"
  base="${base%.md}"
  local f
  for f in "$dir/$base.md" "$dir/$base"; do
    if [[ -f "$f" ]]; then
      sed -n 's/^title: "\(.*\)"$/\1/p' "$f" | head -1
      return 0
    fi
  done
}

remove_cmd() {
  local target="${1:-}"
  local dir
  dir="$(posts_dir)"

  # Sem alvo: lista os posts numerados e pergunta qual remover
  if [[ -z "$target" ]]; then
    local posts=() f
    while IFS= read -r f; do
      posts+=("$f")
    done < <(find "$dir" -maxdepth 1 -name '*.md' | sort)
    if [[ ${#posts[@]} -eq 0 ]]; then
      echo "Nenhum post .md em $dir."
      exit 0
    fi
    echo "Posts em $dir:"
    local i
    for i in "${!posts[@]}"; do
      printf '  %2d) %s\n' "$((i + 1))" "$(basename "${posts[$i]}")"
    done
    local n
    if ! read -r -p "Qual remover? (número, Enter = cancelar): " n; then
      echo
      echo "Cancelado."
      exit 0
    fi
    if [[ -z "$n" ]]; then
      echo "Cancelado."
      exit 0
    fi
    if ! [[ "$n" =~ ^[0-9]+$ ]] || (( n < 1 || n > ${#posts[@]} )); then
      echo "Erro: opção inválida '$n'." >&2
      exit 1
    fi
    target="$(basename "${posts[$((n - 1))]}")"
  fi

  # Confirmação antes de apagar (o CLI valida alvo inexistente/ambíguo)
  local title
  title="$(post_title "$dir" "$target")"
  echo "Remover: ${title:+\"$title\" — }$target"
  local confirm
  if ! read -r -p "Confirmar? (s/N): " confirm; then
    echo
    echo "Cancelado."
    exit 0
  fi
  confirm="${confirm,,}"
  if [[ "$confirm" != "s" && "$confirm" != "sim" ]]; then
    echo "Cancelado."
    exit 0
  fi

  "${MM[@]}" remove "$target"
}

# --- Subcomandos ------------------------------------------------------------
case "${1:-}" in
  prefixes)
    exec "${MM[@]}" prefixes
    ;;
  build)
    exec "${MM[@]}" build
    ;;
  remove | rm)
    shift
    remove_cmd "$@"
    exit 0
    ;;
  --help | -h | help)
    usage
    exit 0
    ;;
  "")
    usage
    echo
    "${MM[@]}" prefixes
    exit 0
    ;;
esac

# --- Criação de post --------------------------------------------------------
# Detecta se --prefix foi passado (e captura o valor seguinte, para validar)
has_prefix=false
prefix_value=""
prev=""
for arg in "$@"; do
  if [[ "$prev" == "--prefix" ]]; then
    prefix_value="$arg"
  fi
  if [[ "$arg" == "--prefix" ]]; then
    has_prefix=true
  fi
  prev="$arg"
done

valid_codes="$(valid_prefixes)"

if [[ "$has_prefix" == true ]]; then
  # --prefix presente: valida antes de criar qualquer arquivo
  if [[ -z "$prefix_value" ]]; then
    echo "Erro: --prefix precisa de um valor (ex.: --prefix tec)." >&2
    exit 1
  fi
  if ! printf '%s\n' "$valid_codes" | grep -qx "$prefix_value"; then
    echo "Erro: prefixo inválido '$prefix_value'. Prefixos válidos: $(echo "$valid_codes" | tr '\n' ' ')" >&2
    exit 1
  fi
else
  # Sem --prefix: pergunta interativamente (Enter ou EOF = sem prefixo)
  "${MM[@]}" prefixes
  while true; do
    if ! read -r -p "Escolha um prefixo (Enter = sem prefixo): " choice; then
      echo
      break
    fi
    if [[ -z "$choice" ]]; then
      break
    fi
    if printf '%s\n' "$valid_codes" | grep -qx "$choice"; then
      set -- "$@" --prefix "$choice"
      break
    fi
    echo "Prefixo inválido: '$choice'. Tente de novo (Enter = sem prefixo)."
  done
fi

"${MM[@]}" new "$@"

echo
echo "Dica: rode './scripts/new-post.sh build' (ou 'npm run post:build') para atualizar o index.json."
