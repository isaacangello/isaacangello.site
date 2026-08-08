#!/bin/sh
# new-post.sh — Cria um novo post no blog via markdown-maverik
# Uso: ./scripts/new-post.sh "Título do Post" [--prefix tec]
#      ./scripts/new-post.sh "Título" --prefix dev --tags laravel,php

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SCRIPT_DIR"

exec npx --no-install markdown-maverik new "$@"
