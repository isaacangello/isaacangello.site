#!/bin/bash
# new-post.sh — Interface para o markdown-maverik
#
# Uso:
#   ./scripts/new-post.sh "Título do Post" [--prefix <code>] [--dir <pasta>]
#   ./scripts/new-post.sh prefixes    # lista os prefixos configurados
#   ./scripts/new-post.sh build       # regenera o index.json do blog
#
# Opções repassadas ao 'markdown-maverik new':
#   --prefix <code>   Prefixo do post (ex.: tec, dev, pol, rel, others).
#                     Se omitido, o script pergunta interativamente.
#   --dir <pasta>     Pasta de destino dos posts (default: config.dir).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SCRIPT_DIR"

MM=(npx --no-install markdown-maverik)

usage() {
  cat <<'EOF'
Uso:
  ./scripts/new-post.sh "Título do Post" [--prefix <code>] [--dir <pasta>]
  ./scripts/new-post.sh prefixes    # lista os prefixos configurados
  ./scripts/new-post.sh build       # regenera o index.json do blog
  ./scripts/new-post.sh --help      # mostra esta ajuda

Opções repassadas ao 'markdown-maverik new':
  --prefix <code>   Prefixo do post (ex.: tec, dev, pol, rel, others).
                    Se omitido, o script pergunta interativamente.
  --dir <pasta>     Pasta de destino dos posts (default: config.dir).
EOF
}

# Códigos de prefixo válidos (primeira coluna de 'markdown-maverik prefixes')
valid_prefixes() {
  "${MM[@]}" prefixes | awk 'NR > 1 {print $1}'
}

# --- Subcomandos ------------------------------------------------------------
case "${1:-}" in
  prefixes)
    exec "${MM[@]}" prefixes
    ;;
  build)
    exec "${MM[@]}" build
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
