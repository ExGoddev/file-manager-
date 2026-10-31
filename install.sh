#!/data/data/com.termux/files/usr/bin/bash

set -Eeuo pipefail

APP_DIR="$HOME/.file-manager"
DB="$APP_DIR/filebrowser.db"
SHARED_DIR="$HOME/storage/shared"
DEFAULT_PORT="8080"
SERVER_PID=""

cleanup() {
    if [ -n "${SERVER_PID:-}" ] && kill -0 "$SERVER_PID" 2>/dev/null; then
        echo
        echo "Encerrando o servidor..."
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
        echo "Servidor encerrado."
    fi
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
    echo
    echo "O armazenamento compartilhado não está acessível."
    echo "Verifique a permissão de arquivos do Termux."
    exit 1
fi

echo "Acesso ao armazenamento confirmado."

echo
echo "[2/6] Instalando dependências..."

pkg install wget tar python -y

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
        echo
        echo "Arquitetura não suportada: $ARCH"
        exit 1
        ;;
esac

echo "Arquitetura detectada: $ARCH"

echo
echo "[4/6] Verificando File Browser..."

if ! command -v filebrowser >/dev/null 2>&1; then

    echo "File Browser não encontrado."
    echo "Baixando..."

    TEMP_DIR="$(mktemp -d)"

    cd "$TEMP_DIR"

    wget --show-progress \
        "https://github.com/filebrowser/filebrowser/releases/latest/download/$FILE"

    tar -xzf "$FILE"

    if [ ! -f "filebrowser" ]; then
        echo
        echo "O executável do File Browser não foi encontrado."
        exit 1
    fi

    install -m 755 filebrowser "$PREFIX/bin/filebrowser"

    cd "$HOME"

    rm -rf "$TEMP_DIR"

    echo
    echo "File Browser instalado com sucesso."

else

    echo "File Browser já está instalado."

fi

echo
filebrowser version

echo
echo "[5/6] Configurando servidor..."

FIRST_INSTALL="false"

if [ ! -f "$DB" ]; then

    echo "Criando banco de dados..."

    filebrowser -d "$DB" config init >/dev/null

    FIRST_INSTALL="true"

fi

if [ "$FIRST_INSTALL" = "true" ]; then

    echo
    echo "======================================"
    echo "         CRIAR USUÁRIO"
    echo "======================================"
    echo

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
        --perm.admin >/dev/null

    unset PASSWORD PASSWORD_CONFIRMATION

    echo
    echo "Usuário criado."

else

    echo "O banco de dados já existe."
    echo "A criação de usuário será ignorada."

fi

echo
echo "======================================"
echo "       CONFIGURAÇÃO DA PORTA"
echo "======================================"
echo

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

    break

done

echo
echo "Porta escolhida: $PORT"

echo
echo "Detectando IP local..."

IP="$(python - <<'PY' 2>/dev/null || true
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

try:
    s.connect(("1.1.1.1", 80))
    ip = s.getsockname()[0]

    if ip and not ip.startswith("127."):
        print(ip)

except OSError:
    pass

finally:
    s.close()
PY
)"

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
    echo
    echo "O servidor não conseguiu iniciar."
    SERVER_PID=""
    exit 1
fi

echo
echo "======================================"
echo "       SERVIDOR LOCAL INICIADO"
echo "======================================"
echo

if [ -n "$IP" ]; then

    echo "Acesse pelo navegador:"
    echo
    echo "http://$IP:$PORT"

else

    echo "Servidor iniciado na porta $PORT."
    echo
    echo "Não foi possível detectar automaticamente"
    echo "o endereço IP deste aparelho."
    echo
    echo "Consulte:"
    echo "Configurações > Wi-Fi > sua rede > Endereço IP"

fi

echo
echo "Diretório compartilhado:"
echo "$SHARED_DIR"
echo
echo "Pressione CTRL+C para encerrar."
echo

wait "$SERVER_PID"

