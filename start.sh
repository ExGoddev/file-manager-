#!/data/data/com.termux/files/usr/bin/bash

set -Eeuo pipefail

DB="$HOME/.file-manager/filebrowser.db"
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
echo "       INICIANDO SERVIDOR LOCAL"
echo "======================================"
echo

if ! command -v filebrowser >/dev/null 2>&1; then
    echo "File Browser não está instalado."
    echo
    echo "Execute primeiro:"
    echo "bash install.sh"
    exit 1
fi

if [ ! -f "$DB" ]; then
    echo "Configuração do servidor não encontrada."
    echo
    echo "Execute primeiro:"
    echo "bash install.sh"
    exit 1
fi

if [ ! -d "$SHARED_DIR" ]; then
    echo "Armazenamento compartilhado não encontrado."
    echo
    echo "Execute primeiro:"
    echo "bash install.sh"
    exit 1
fi

if ! command -v python >/dev/null 2>&1; then
    echo "Python não está instalado."
    echo
    echo "Execute primeiro:"
    echo "bash install.sh"
    exit 1
fi

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

if [ -z "$IP" ]; then
    echo
    echo "Não foi possível detectar o IP local."
    echo "Verifique se o Wi-Fi está conectado."
    exit 1
fi

echo "IP detectado: $IP"

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
echo "Iniciando servidor..."

filebrowser \
    -a "$IP" \
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
echo "Acesse pelo navegador:"
echo
echo "http://$IP:$PORT"
echo
echo "Outros dispositivos precisam estar"
echo "conectados à mesma rede Wi-Fi."
echo
echo "Pressione CTRL+C para encerrar."
echo

wait "$SERVER_PID"
