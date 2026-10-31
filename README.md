# 📱 Servidor de arquivos local no Android

Script para transformar um dispositivo Android em um servidor de arquivos local utilizando Termux e File Browser.

Este projeto é uma versão modificada e aprimorada do projeto original [`gio-yaml/android-nas`](https://github.com/gio-yaml/android-nas).

## Instalação

Instale o [Termux](https://f-droid.org/packages/com.termux/) e execute:

```bash
pkg update
pkg install git -y
```

Clone o projeto:

```bash
git clone https://github.com/ExGoddev/file-manager-.git
```

Entre na pasta:

```bash
cd file-manager-
```

Execute:

```bash
bash install.sh
```

O instalador vai solicitar as permissões necessárias e permitir configurar:

- usuário;
- senha;
- porta do servidor.

Ao finalizar, será exibido um endereço semelhante a:

```text
http://192.168.1.10:8080
```

Abra esse endereço em outro dispositivo conectado à mesma rede Wi-Fi e faça login.

## ⚠️ Importante

Este projeto foi desenvolvido para testes em **rede local**. Não exponha diretamente a porta do servidor à internet.

## Créditos

Baseado no projeto original [gio-yaml/android-nas](https://github.com/gio-yaml/android-nas).

Modificações e melhorias desta versão por **ExGoddev**.
