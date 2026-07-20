#!/bin/sh
# new-post.sh — Cria um novo post no blog
# Uso: ./scripts/new-post.sh "Título do Post"

set -e

if [ $# -eq 0 ]; then
  echo "Uso: $0 \"Título do Post\""
  exit 1
fi

TITLE="$*"
DATE=$(date +%Y-%m-%d)
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
FILENAME="${DATE}-${SLUG}.md"
POSTS_DIR="$(dirname "$0")/../src/posts"

cat > "$POSTS_DIR/$FILENAME" <<EOF
---
title: "$TITLE"
date: $DATE
tags: []
description: "Breve descrição do post"
---

Escreva seu conteúdo em **Markdown** aqui...
EOF

echo "Criado: src/posts/$FILENAME"
