# 🚀 Hello World - Susa Plugin

Plugin de exemplo para o Susa CLI demonstrando como criar seus próprios plugins.

## 📋 Sobre

Este plugin serve como **template de referência** para criar plugins do Susa CLI.

**O que este exemplo demonstra:**

- ✅ Estrutura básica de diretórios
- ✅ Configuração via YAML (`config.yaml`)
- ✅ Uso de variáveis de ambiente
- ✅ Suporte a arquivos `.env`
- ✅ Tratamento de argumentos
- ✅ Sistema de ajuda integrado
- ✅ Uso das bibliotecas do Susa (logger, colors, etc.)

## 🔧 Instalação

```bash
# Via Git
susa self plugin add https://github.com/duducp/susa-plugin-hello-world.git

# Verificar instalação
susa self plugin list
```

## 📚 Uso

```bash
# Comando básico
susa demo hello

# Com nome personalizado
susa demo hello --name "João"

# Ver ajuda
susa demo hello --help
```

## 🗂️ Estrutura do Plugin

```text
susa-plugin-hello-world/
├── README.md              # Documentação
├── demo/                  # Categoria
│   ├── config.yaml        # Config da categoria
│   └── hello/             # Comando
│       ├── config.yaml    # Config do comando
│       ├── main.sh        # Script principal
│       ├── .env           # Variáveis (opcional)
│       └── .env.example   # Exemplo de .env
```

## 📝 Arquivos de Configuração

### Categoria: `demo/config.yaml`

```yaml
name: "Demo"
description: "Comandos de demonstração do plugin"
```

### Comando: `demo/hello/config.yaml`

```yaml
name: "Hello World"
description: "Exibe uma mensagem de saudação"
entrypoint: "main.sh"
sudo: false
os: ["linux", "mac"]

# Arquivos .env (opcional)
env_files:
  - ".env"

# Variáveis de ambiente
envs:
  HELLO_PREFIX: "👋"
  HELLO_COLOR: "green"
```

## 🚀 Como Criar Seu Próprio Plugin

### 1. Clone este repositório como base

```bash
git clone https://github.com/duducp/susa-plugin-hello-world.git meu-plugin
cd meu-plugin
```

### 2. Renomeie a estrutura

```bash
# Renomear categoria de 'demo' para sua categoria
mv demo/ minha-categoria/

# Renomear comando de 'hello' para seu comando
mv minha-categoria/hello/ minha-categoria/meu-comando/
```

### 3. Edite os arquivos

- `README.md` - Documentação do seu plugin
- `minha-categoria/config.yaml` - Nome e descrição da categoria
- `minha-categoria/meu-comando/config.yaml` - Configuração do comando
- `minha-categoria/meu-comando/main.sh` - Lógica do comando

### 4. Teste localmente

```bash
# Instalar localmente
susa self plugin add /caminho/completo/para/meu-plugin

# Testar
susa minha-categoria meu-comando
```

### 5. Publique no GitHub

```bash
git remote set-url origin https://github.com/seu-usuario/meu-plugin.git
git add .
git commit -m "Meu plugin customizado"
git push -u origin main
```

## 🛠️ Gerenciar Plugin

```bash
# Listar plugins instalados
susa self plugin list

# Atualizar plugin
susa self plugin update susa-plugin-hello-world

# Atualizar sem confirmação (útil para scripts/CI)
susa self plugin update susa-plugin-hello-world -y

# Atualizar com logs detalhados
susa self plugin update susa-plugin-hello-world -v

# Remover plugin
susa self plugin remove susa-plugin-hello-world

# Remover sem confirmação e modo silencioso
susa self plugin remove susa-plugin-hello-world -y -q
```

## 🎓 Desenvolvimento de Plugins

Este plugin serve como base para criar seus próprios plugins. Principais conceitos:

1. **Categorias**: Organize comandos relacionados sob uma categoria comum
2. **Configuração YAML**: Defina metadados e comportamento dos comandos
3. **Scripts Bash**: Implemente a lógica dos comandos
4. **Funções do Susa**: Utilize funções auxiliares como `setup_command_env`, `show_help`, `log_error`

### Testando o Plugin

Durante o desenvolvimento, teste o plugin instalando-o localmente:

```bash
# Instalar plugin em modo desenvolvimento
cd susa-plugin-hello-world
susa self plugin add .

# Testar comandos
susa demo hello
susa demo hello --name "João"

# Fazer alterações no código e testar novamente
# As mudanças são refletidas imediatamente!
susa demo hello --name "Maria"
```

Plugins instalados localmente (modo dev) refletem alterações automaticamente - não é necessário reinstalar após cada modificação.

Para maiores informações consulte a documentação de [plugins](https://duducp.github.io/susa/plugins/overview/).

## 🔍 Qualidade de Código

Este plugin inclui configurações para manter a qualidade do código Shell.

### Ferramentas Incluídas

- **ShellCheck** - Análise estática de scripts shell
- **shfmt** - Formatador de código shell
- **pre-commit** - Hooks automáticos de verificação
- **yamllint** - Validação de arquivos YAML

### Instalação Rápida

```bash
# Instalar dependências
make install-dev
```

### Comandos de Desenvolvimento

```bash
# Ver todos os comandos disponíveis
make help

# Verificar código (shellcheck)
make lint

# Formatar código automaticamente
make format

# Limpar arquivos temporários
make clean
```

### Configuração do Editor

O plugin já vem com configurações prontas para VS Code:

1. Abra o projeto no VS Code
2. Instale as extensões recomendadas (VS Code irá sugerir automaticamente)
3. As configurações em `.vscode/settings.json` já estão prontas

**Extensões recomendadas:**

- ShellCheck (`timonwong.shellcheck`)
- Shell Format (`foxundermoon.shell-format`)
- YAML (`redhat.vscode-yaml`)
- EditorConfig (`editorconfig.editorconfig`)

### Integração CI/CD

O arquivo `.pre-commit-config.yaml` pode ser usado em pipelines CI:

```yaml
# GitHub Actions
- name: Run pre-commit
  uses: pre-commit/action@v3.0.0
```

### Variáveis de Ambiente Disponíveis

Ao executar scripts dentro do Susa CLI, você tem acesso as bibliotecas listadas [aqui](https://duducp.github.io/susa/reference/libraries/).

## 📖 Recursos Adicionais

- **Documentação Oficial**: [Visão Geral de Plugins](https://duducp.github.io/susa/plugins/overview/)
- **API de Plugins**: Guias detalhados sobre desenvolvimento
- **Exemplos**: Mais exemplos de plugins na organização

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:

1. Fazer fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abrir um Pull Request
