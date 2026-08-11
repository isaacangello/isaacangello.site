#!/bin/bash
# deploy.sh — Deploy manual para InfinityFree e/ou 50webs
# Uso: ./scripts/deploy.sh [infinityfree|50webs|all]
#   default: infinityfree
# Requer: .env.ftp na raiz do projeto, lftp instalado

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SCRIPT_DIR"

TARGET="${1:-infinityfree}"

if [ ! -f .env.ftp ]; then
  echo "Erro: .env.ftp não encontrado na raiz do projeto."
  echo "Copie .env.ftp.example para .env.ftp e preencha as credenciais."
  exit 1
fi

source .env.ftp

deploy_50webs() {
  if [ -z "$FTP_HOST" ] || [ -z "$FTP_USERNAME" ] || [ -z "$FTP_PASSWORD" ]; then
    echo "Erro: credenciais FTP (50webs) incompletas no .env.ftp"
    exit 1
  fi
  local remote="${FTP_PATH:-isaacangelo.50webs.com}"
  echo "=== Deploy 50webs -> $FTP_HOST:$remote ==="
  lftp -c "
    set ftp:ssl-allow no
    set net:max-retries 3
    set net:timeout 30
    open -u '$FTP_USERNAME','$FTP_PASSWORD' $FTP_HOST
    mirror -R --verbose \
      --exclude .env.ftp \
      --exclude node_modules/ \
      --exclude .git/ \
      ./public_html/ $remote/
  "
  echo "=== Deploy 50webs concluído ==="
}

deploy_infinityfree() {
  if [ -z "$INFINITY_FREE_HOST" ] || [ -z "$INFINITY_FREE_USER" ] || [ -z "$INFINITY_FREE_PASSWORD" ]; then
    echo "Erro: credenciais FTP (InfinityFree) incompletas no .env.ftp"
    exit 1
  fi
  echo "=== Deploy InfinityFree -> $INFINITY_FREE_HOST:/htdocs/ ==="
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
  echo "=== Deploy InfinityFree concluído ==="
}

echo "=== Instalando dependências ==="
npm ci

echo "=== Build ==="
npm run build

case "$TARGET" in
  all)
    deploy_infinityfree
    deploy_50webs
    ;;
  50webs)
    deploy_50webs
    ;;
  infinityfree|*)
    deploy_infinityfree
    ;;
esac
