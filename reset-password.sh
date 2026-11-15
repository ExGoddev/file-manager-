#!/data/data/com.termux/files/usr/bin/bash

set -u

DB="$HOME/.file-manager/filebrowser.db"

echo "======================================"
echo "          REDEFINIR SENHA"
echo "======================================"
echo

if ! command -v filebrowser >/dev/null 2>&1; then
    echo "Erro: File Browser não está instalado."
    echo "Execute primeiro:"
    echo
    echo "bash install.sh"
    exit 1
fi

if [ ! -f "$DB" ]; then
    echo "Erro: banco de dados não encontrado."
    echo "Execute primeiro:"
    echo
    echo "bash install.sh"
    exit 1
fi

echo "Usuários cadastrados:"
echo

filebrowser -d "$DB" users ls

echo

while true; do
    read -rp "Digite o nome do usuário: " USERNAME

    if [ -z "$USERNAME" ]; then
        echo
        echo "O nome do usuário não pode ficar vazio."
        echo
        continue
    fi

    if filebrowser -d "$DB" users find "$USERNAME" >/dev/null 2>&1; then
        break
    fi

    echo
    echo "Usuário não encontrado: $USERNAME"
    echo "Digite novamente."
    echo
done

while true; do
    echo

    read -rsp "Digite a nova senha: " PASSWORD
    echo

    if [ -z "$PASSWORD" ]; then
        echo
        echo "A senha não pode ficar vazia."
        continue
    fi

    if [ "${#PASSWORD}" -lt 12 ]; then
        echo
        echo "A senha precisa ter no mínimo 12 caracteres."
        continue
    fi

    read -rsp "Digite novamente a nova senha: " PASSWORD_CONFIRMATION
    echo

    if [ "$PASSWORD" != "$PASSWORD_CONFIRMATION" ]; then
        echo
        echo "As senhas não coincidem."
        echo "Tente novamente."
        continue
    fi

    break
done

echo
echo "Redefinindo senha..."

if filebrowser \
    -d "$DB" \
    users update "$USERNAME" \
    -p "$PASSWORD" >/dev/null; then

    unset PASSWORD PASSWORD_CONFIRMATION

    echo
    echo "======================================"
    echo "   SENHA REDEFINIDA COM SUCESSO!"
    echo "======================================"
    echo
    echo "Usuário: $USERNAME"
    echo
    echo "Agora você pode iniciar o servidor com:"
    echo
    echo "bash install.sh"
    echo
else
    unset PASSWORD PASSWORD_CONFIRMATION

    echo
    echo "Erro ao redefinir a senha."
    exit 1
fi

