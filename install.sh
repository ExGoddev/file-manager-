#!/data/data/com.termux/files/usr/bin/bash

set -Eeuo pipefail

APP_DIR="$HOME/.file-manager"
DB="$APP_DIR/filebrowser.db"
SHARED_DIR="$HOME/storage/shared"
DEFAULT_PORT="8080"
SERVER_PID=""

cleanup() {
    echo
    echo "Encerrando o servidor..."

    if [ -n "${SERVER_PID:-}" ] && kill -0 "$SERVER_PID" 2>/dev/null; then
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
    fi

    echo "Servidor encerrado."
}

trap cleanup INT TERM EXIT

echo "======================================"
echo "   SERVIDOR DE ARQUIVOS LOCAL"
echo "======================================"
echo

mkdir -p "$APP_DIR"

echo "[1/6] Verificando acesso aos arquivos..."

if [ ! -d "$SHARED_DIR" ]; then
    termux-setup-storage

    echo
    echo "Permita o acesso aos arquivos."
    echo "Depois pressione ENTER."
    read -r
fi

if [ ! -d "$SHARED_DIR" ]; then
    echo "O armazenamento compartilhado não está acessível."
    echo "Verifique a permissão de arquivos do Termux."
    exit 1
fi

echo "Acesso ao armazenamento confirmado."

echo
echo "[2/6] Instalando dependências..."

pkg install wget tar iproute2 -y

echo
echo "[3/6] Verificando arquitetura..."

ARCH="$(uname -m)"

case "$ARCH" in
    aarch64)
        FILE="linux-arm64-filebrowser.tar.gz"
        ;;
    x86_64)
        FILE="linux-amd64-filebrowser.tar.gz"
        ;;
    i686|x86)
        FILE="linux-386-filebrowser.tar.gz"
        ;;
    armv7l|arm)
        FILE="linux-armv5-filebrowser.tar.gz"
        ;;
    *)
        echo "Arquitetura não suportada: $ARCH"
        exit 1
        ;;
esac

echo "Arquitetura detectada: $ARCH"

if ! command -v filebrowser >/dev/null 2>&1; then
    echo
    echo "[4/6] Instalando File Browser..."

    TEMP_DIR="$(mktemp -d)"

    trap 'rm -rf "$TEMP_DIR"; cleanup' INT TERM EXIT

    cd "$TEMP_DIR"

    DOWNLOAD_BASE="https://github.com"
    DOWNLOAD_PATH="/filebrowser/filebrowser/releases/latest/download"

    wget --show-progress \
        "$DOWNLOAD_BASE$DOWNLOAD_PATH/$FILE"

    tar -xzf "$FILE"

    if [ ! -f "filebrowser" ]; then
        echo "O executável não foi encontrado no pacote."
        exit 1
    fi

    install -m 755 filebrowser "$PREFIX/bin/filebrowser"

    cd "$HOME"
    rm -rf "$TEMP_DIR"

    trap cleanup INT TERM EXIT
else
    echo
    echo "[4/6] File Browser já está instalado."
fi

echo
filebrowser version

echo
echo "[5/6] Configurando servidor..."

FIRST_INSTALL="false"

if [ ! -f "$DB" ]; then
    filebrowser -d "$DB" config init
    FIRST_INSTALL="true"
fi

if [ "$FIRST_INSTALL" = "true" ]; then
    while true; do
        read -rp "Nome de usuário: " USERNAME

        if [ -n "$USERNAME" ]; then
            break
        fi

        echo "O usuário não pode ficar vazio."
    done

    while true; do
        read -rsp "Senha com pelo menos 12 caracteres: " PASSWORD
        echo

        if [ "${#PASSWORD}" -lt 12 ]; then
            echo "A senha precisa ter pelo menos 12 caracteres."
            continue
        fi

        read -rsp "Repita a senha: " PASSWORD_CONFIRMATION
        echo

        if [ "$PASSWORD" = "$PASSWORD_CONFIRMATION" ]; then
            break
        fi

        echo "As senhas não coincidem."
    done

    filebrowser \
        -d "$DB" \
        users add "$USERNAME" "$PASSWORD" \
        --perm.admin

    unset PASSWORD PASSWORD_CONFIRMATION
else
    echo "O banco de dados já existe."
    echo "A criação de usuário será ignorada."
fi

while true; do
    read -rp "Porta [$DEFAULT_PORT]: " PORT
    PORT="${PORT:-$DEFAULT_PORT}"

    if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
        echo "Digite somente números."
        continue
    fi

    if [ "$PORT" -lt 1024 ] || [ "$PORT" -gt 65535 ]; then
        echo "Escolha uma porta entre 1024 e 65535."
        continue
    fi

    if ss -ltn 2>/dev/null | grep -q ":$PORT "; then
        echo "A porta $PORT já está sendo utilizada."
        continue
    fi

    break
done

IP="$(
    ip -4 route get 1.1.1.1 2>/dev/null |
    awk '{for (i=1; i<=NF; i++) if ($i=="src") print $(i+1)}' |
    head -n 1
)"

if [ -z "$IP" ]; then
    IP="$(
        ip -4 addr show 2>/dev/null |
        awk '/inet / && $2 !~ /^127\./ {sub(/\/.*/, "", $2); print $2; exit}'
    )"
fi

echo
echo "[6/6] Iniciando servidor local..."

filebrowser \
    -a 0.0.0.0 \
    -p "$PORT" \
    -r "$SHARED_DIR" \
    -d "$DB" &

SERVER_PID=$!

sleep 2

if ! kill -0 "$SERVER_PID" 2>/dev/null; then
    echo "O servidor não conseguiu iniciar."
    exit 1
fi

echo
echo "======================================"
echo "       SERVIDOR LOCAL INICIADO"
echo "======================================"

if [ -n "$IP" ]; then
    echo "Endereço local: http://$IP:$PORT"
else
    echo "Não foi possível detectar o IP."
    echo "Consulte o endereço Wi-Fi nas configurações do Android."
fi

echo
echo "Diretório compartilhado: $SHARED_DIR"
echo "Pressione CTRL+C para encerrar."
echo

wait "$SERVER_PID"
