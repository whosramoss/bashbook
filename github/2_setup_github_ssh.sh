#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 2_setup_github_ssh.sh
# Description :: Create a SSK key
# Compatible with: Linux · Windows
# -------------------------------------------------------

set -e

echo "=========================================="
echo " Configurador SSH para GitHub"
echo "=========================================="
echo

# Detectar sistema operacional
OS="$(uname -s)"

open_url() {
    local url="$1"

    case "$OS" in
        Linux*)
            if command -v xdg-open >/dev/null 2>&1; then
                xdg-open "$url" >/dev/null 2>&1 &
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            start "$url" >/dev/null 2>&1
            ;;
        Darwin*)
            open "$url"
            ;;
    esac
}

copy_clipboard() {
    local file="$1"

    case "$OS" in
        Linux*)
            if command -v xclip >/dev/null 2>&1; then
                xclip -selection clipboard < "$file"
                return 0
            elif command -v wl-copy >/dev/null 2>&1; then
                wl-copy < "$file"
                return 0
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            if command -v clip.exe >/dev/null 2>&1; then
                cat "$file" | clip.exe
                return 0
            fi
            ;;
        Darwin*)
            if command -v pbcopy >/dev/null 2>&1; then
                pbcopy < "$file"
                return 0
            fi
            ;;
    esac

    return 1
}

echo "Verificando Git..."

if ! command -v git >/dev/null 2>&1; then
    echo
    echo "ERRO: Git não encontrado."
    echo "Instale o Git antes de continuar."
    exit 1
fi

echo "Git encontrado:"
git --version

echo
echo "Verificando chaves SSH existentes..."

SSH_DIR="$HOME/.ssh"

if [ -f "$SSH_DIR/id_ed25519" ] || \
   [ -f "$SSH_DIR/id_ed25519.pub" ] || \
   [ -f "$SSH_DIR/id_rsa" ] || \
   [ -f "$SSH_DIR/id_rsa.pub" ]; then

    echo
    echo "Já existe uma chave SSH configurada."
    echo
    echo "Arquivos encontrados:"
    ls -1 "$SSH_DIR"
    echo
    echo "Processo interrompido para evitar sobrescrever chaves existentes."
    exit 0
fi

echo
read -rp "Digite seu email do GitHub: " EMAIL

echo
echo "Gerando chave SSH..."

ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_DIR/id_ed25519" -N ""

echo
echo "Iniciando ssh-agent..."

eval "$(ssh-agent -s)"

echo
echo "Adicionando chave ao agente..."

ssh-add "$SSH_DIR/id_ed25519"

echo
echo "=========================================="
echo "CHAVE PÚBLICA"
echo "=========================================="

cat "$SSH_DIR/id_ed25519.pub"

echo
echo "=========================================="

if copy_clipboard "$SSH_DIR/id_ed25519.pub"; then
    echo
    echo "✓ Chave copiada para a área de transferência."
else
    echo
    echo "Não foi possível copiar automaticamente."
fi

echo
echo "Abrindo página do GitHub para adicionar a chave..."

open_url "https://github.com/settings/keys"

echo
echo "Passos:"
echo
echo "1. Clique em 'New SSH Key'"
echo "2. Cole a chave copiada"
echo "3. Salve"
echo

read -rp "Pressione ENTER após adicionar a chave no GitHub..."

echo
echo "Testando conexão com GitHub..."
echo

ssh -T git@github.com || true

echo
echo "=========================================="
echo "Processo concluído."
echo "=========================================="
