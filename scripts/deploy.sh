#!/bin/bash
# deploy.sh — Deploy manual para InfinityFree
# Uso: ./scripts/deploy.sh
# Requer: .env.ftp na raiz do projeto, lftp instalado

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SCRIPT_DIR"

if [ ! -f .env.ftp ]; then
  echo "Erro: .env.ftp não encontrado na raiz do projeto."
  echo "Copie .env.ftp.example para .env.ftp e preencha as credenciais."
  exit 1
fi

source .env.ftp

if [ -z "$INFINITY_FREE_HOST" ] || [ -z "$INFINITY_FREE_USER" ] || [ -z "$INFINITY_FREE_PASSWORD" ]; then
  echo "Erro: credenciais FTP incompletas no .env.ftp"
  exit 1
fi

echo "=== Instalando dependências ==="
npm ci

echo "=== Build ==="
npm run build

echo "=== Deploy via FTP ==="
lftp -c "
  set ftp:ssl-allow no
  set net:max-retries 3
  set net:timeout 30
  open -u '$INFINITY_FREE_USER','$INFINITY_FREE_PASSWORD' $INFINITY_FREE_HOST
  mirror -R --verbose \
    --exclude .env.ftp \
    --exclude node_modules/ \
    --exclude .git/ \
    ./public_html/ /htdocs/
"

echo "=== Deploy concluído ==="
