# 📱 Servidor de arquivos local no Android

Transforme um celular Android em um servidor de arquivos local usando **Termux + File Browser**.

Você poderá acessar os arquivos do celular pelo navegador de outro celular, tablet ou computador conectado à mesma rede Wi-Fi.

## 📋 Requisitos

- celular Android
- Termux
- conexão Wi-Fi
- não precisa de root

## 📥 Instalando o Termux

Para este projeto, recomendamos instalar o **Termux pelo F-Droid**:

https://f-droid.org/packages/com.termux/

Baixe e instale o Termux pelo link acima. Depois abra o aplicativo e continue com as instruções abaixo.

> ⚠️ Evite misturar instalações do Termux e seus complementos provenientes de fontes diferentes.

## 🚀 Primeira instalação

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

Digite o usuário que deseja utilizar e pressione **ENTER**.

Depois será solicitada uma senha:

```text
Senha com pelo menos 12 caracteres:
```

> ⚠️ **Importante:** enquanto você digita a senha, nada aparece na tela. Nem letras, números ou `*****`. Isso é normal no Termux.

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

Abra exatamente o endereço mostrado pelo Termux.

Para acessar de outro celular, tablet ou computador, o dispositivo precisa estar conectado à **mesma rede Wi-Fi** do celular que está executando o servidor.

**Não é necessário instalar o projeto, Termux ou File Browser nos outros dispositivos.**

Nos outros dispositivos basta abrir o endereço mostrado pelo servidor em um navegador e fazer login usando o usuário e a senha criados durante a instalação.

## ▶️ Iniciando o servidor novamente

O comando:

```bash
bash install.sh
```

é destinado principalmente à **primeira instalação**.

Depois que o servidor já estiver instalado e configurado, você **não precisa repetir todo o processo de instalação**.

Para iniciar novamente, abra o Termux e entre na pasta:

```bash
cd ~/file-manager-
```

Depois execute:

```bash
bash start.sh
```

O script detectará o IP atual do celular e perguntará qual porta deverá ser utilizada.

Para continuar usando a porta padrão `8080`, apenas pressione **ENTER**.

Depois abra nos outros dispositivos o endereço mostrado pelo servidor.

## 🔑 Esqueci minha senha

Se você esquecer a senha, **não precisa reinstalar o servidor nem apagar a configuração**.

Primeiro, se o servidor estiver funcionando, encerre usando:

```text
CTRL+C
```

Depois entre na pasta do projeto:

```bash
cd ~/file-manager-
```

Execute:

```bash
bash reset-password.sh
```

O script mostrará os usuários cadastrados e perguntará qual usuário terá a senha redefinida.

Depois aparecerá:

```text
Digite a nova senha:
Digite novamente a nova senha:
```

> ⚠️ A nova senha também ficará invisível enquanto estiver sendo digitada. Isso é normal.

A senha precisa ter no mínimo **12 caracteres**.

Se as duas senhas não forem iguais, o script avisará e solicitará as senhas novamente.

Quando a alteração for concluída corretamente aparecerá:

```text
SENHA REDEFINIDA COM SUCESSO!
```

Depois inicie novamente o servidor:

```bash
bash start.sh
```

E utilize a nova senha para entrar.

## 🛑 Encerrando o servidor

Para parar o servidor, volte ao Termux e pressione:

```text
CTRL+C
```

## 📌 Comandos principais

### Primeira instalação

```bash
bash install.sh
```

### Iniciar o servidor depois de instalado

```bash
bash start.sh
```

### Redefinir uma senha esquecida

```bash
bash reset-password.sh
```

### Encerrar o servidor

```text
CTRL+C
```

## ⚠️ Importante

Este projeto foi desenvolvido para uso e testes em **rede local**.

O celular que executa o servidor e os dispositivos que acessam os arquivos precisam conseguir se comunicar pela mesma rede local.

Não exponha diretamente a porta do File Browser à internet.

Mantenha sempre uma cópia de segurança dos seus arquivos importantes.

## 🙏 Créditos

Este projeto é uma versão modificada e aprimorada do projeto original:

**gio-yaml/android-nas**

https://github.com/gio-yaml/android-nas

Modificações e melhorias desta versão por **ExGoddev**.
