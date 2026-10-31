# 📱 Servidor de arquivos local no Android

Transforme um celular Android em um servidor de arquivos local usando **Termux + File Browser**.

O servidor permite acessar os arquivos do celular pelo navegador de outro celular, tablet ou computador conectado à mesma rede Wi-Fi.

## 📋 Requisitos

- Android
- Termux
- Wi-Fi
- Não precisa de root

## 🚀 Instalação

### 1. Atualize o Termux

```bash
pkg update
```

### 2. Instale o Git

```bash
pkg install git -y
```

### 3. Clone o projeto

```bash
git clone https://github.com/ExGoddev/file-manager-.git
```

### 4. Entre na pasta

```bash
cd file-manager-
```

### 5. Execute o instalador

```bash
bash install.sh
```

O instalador irá:

- configurar o acesso aos arquivos do Android;
- instalar as dependências;
- detectar a arquitetura do aparelho;
- instalar o File Browser;
- criar o banco de dados;
- solicitar usuário e senha;
- permitir escolher a porta;
- detectar automaticamente o IP local;
- iniciar o servidor.

A porta padrão é:

```text
8080
```

Basta pressionar **ENTER** para utilizá-la.

## 🌐 Acessando o servidor

Quando estiver funcionando, será exibido um endereço parecido com:

```text
http://192.168.1.10:8080
```

Abra esse endereço no navegador de outro dispositivo conectado à mesma rede Wi-Fi.

Entre utilizando o usuário e a senha criados durante a primeira instalação.

## 🛑 Encerrando

Para parar o servidor, pressione:

```text
CTRL+C
```

## ⚠️ Importante

Este projeto foi desenvolvido para uso e testes em **rede local**.

Não exponha diretamente a porta do File Browser à internet.

Mantenha backup dos seus arquivos importantes.

## 🙏 Créditos

Este projeto é uma versão modificada e aprimorada do projeto original:

**gio-yaml/android-nas**

https://github.com/gio-yaml/android-nas

Modificações e melhorias desta versão por **ExGoddev**.

