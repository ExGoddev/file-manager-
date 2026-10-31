# 📱 Servidor de arquivos local no Android

Transforme um celular Android em um servidor de arquivos local usando **Termux + File Browser**.

Você poderá acessar os arquivos do celular pelo navegador de outro celular, tablet ou computador conectado à mesma rede Wi-Fi.

## 📋 Requisitos

- celular Android
- Termux
- conexão Wi-Fi
- não precisa de root

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

O instalador fará a configuração automaticamente.

Na primeira execução, você deverá criar um nome de usuário e uma senha.

## 🔐 Criando usuário e senha

Quando aparecer:

```text
Nome de usuário:
```

digite o usuário que deseja utilizar e pressione **ENTER**.

Depois será solicitada uma senha:

```text
Senha com pelo menos 12 caracteres:
```

> ⚠️ **Importante:** enquanto você digita a senha, nada aparece na tela. Nem letras, nem números e nem `*****`. Isso é normal no Termux.

Digite sua senha normalmente e pressione **ENTER**.

Depois digite novamente a mesma senha para confirmar.

A senha precisa ter pelo menos **12 caracteres**.

## 🔌 Escolhendo a porta

Durante a instalação aparecerá:

```text
Porta ```

A porta padrão é **8080**.

Se quiser usar a porta 8080, **não digite nada**.

Apenas pressione **ENTER** para continuar.

O resultado será:

```text
Porta escolhida: 8080
```

Se quiser utilizar outra porta, digite o número e pressione **ENTER**.

Exemplo:

```text
Porta 8085
Porta escolhida: 8085
```

Para a maioria dos usuários, basta pressionar **ENTER** e continuar utilizando a porta padrão `8080`.

## 🌐 Acessando o servidor

Quando tudo estiver pronto, aparecerá algo parecido com:

```text
SERVIDOR LOCAL INICIADO

Acesse pelo navegador:

http://192.168.1.10:8080
```

Abra o endereço mostrado em um navegador.

Para acessar de outro celular, tablet ou computador, conecte o dispositivo à **mesma rede Wi-Fi** do celular que está executando o servidor.

Depois faça login usando o usuário e a senha criados durante a instalação.

## 🛑 Encerrando o servidor

Para parar o servidor, volte ao Termux e pressione:

```text
CTRL+C
```

## ⚠️ Importante

Este projeto foi desenvolvido para uso e testes em **rede local**.

Não exponha diretamente a porta do File Browser à internet.

Mantenha sempre uma cópia de segurança dos seus arquivos importantes.

## 🙏 Créditos

Este projeto é uma versão modificada e aprimorada do projeto original:

**gio-yaml/android-nas**

https://github.com/gio-yaml/android-nas

Modificações e melhorias desta versão por **ExGoddev**.

