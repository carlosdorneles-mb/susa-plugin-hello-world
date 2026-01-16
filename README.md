# 🚀 Hello World - Susa Plugin

Plugin de exemplo para o Susa CLI demonstrando como criar seus próprios plugins.

## 📋 Sobre

Este plugin serve como **template de referência** para criar plugins do Susa CLI.

**O que este exemplo demonstra:**

- ✅ Estrutura básica de diretórios
- ✅ Configuração via JSON (`command.json` e `category.json`)
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
# Listar comandos da categoria (mostra help complementar)
susa demo

# Opções da categoria
susa demo --list           # Lista todos os comandos disponíveis
susa demo --about          # Informações sobre o plugin

# Comando básico
susa demo hello

# Com nome personalizado
susa demo hello --name "João"

# Ver ajuda do comando
susa demo hello --help
```

## 🗂️ Estrutura do Plugin

```text
susa-plugin-hello-world/
├── README.md              # Documentação
├── plugin.json            # Config do plugin
├── DEVELOPMENT.md         # Guia técnico de desenvolvimento
├── EXAMPLES.md            # Exemplos de estruturas de plugins
├── demo/                  # Categoria
│   ├── category.json      # Config da categoria (com entrypoint)
│   ├── main.sh            # Script da categoria (aceita parâmetros)
│   └── hello/             # Comando
│       ├── command.json   # Config do comando
│       ├── main.sh        # Script principal
│       ├── .env           # Variáveis (opcional)
│       └── .env.example   # Exemplo de .env
```

## 📝 Arquivos de Configuração

### Categoria: `demo/category.json`

```json
{
  "name": "Demo",
  "description": "Comandos de demonstração e exemplos",
  "entrypoint": "main.sh"
}
```

**Nota:** O campo `entrypoint` permite que a categoria aceite parâmetros diretamente (feature avançada). Veja seção "Categoria com Entrypoint" abaixo.

### Comando: `demo/hello/command.json`

```json
{
  "name": "Hello World",
  "description": "Exibe uma mensagem de saudação",
  "entrypoint": "main.sh",
  "sudo": false,
  "os": ["linux", "mac"],
  "env_files": [".env"],
  "envs": {
    "HELLO_PREFIX": "👋",
    "HELLO_COLOR": "green"
  }
}
```

## 🎨 Categoria com Entrypoint (Feature Avançada)

Este plugin demonstra o uso de **entrypoint em categoria**, permitindo que a categoria aceite parâmetros diretamente.

### Como Funciona

Quando uma categoria tem um `entrypoint`:

1. **Sem parâmetros** (`susa demo`) - Lista comandos + mostra help complementar
2. **Com parâmetros** (`susa demo --list`) - Executa o script da categoria
3. **Comando específico** (`susa demo hello`) - Funciona normalmente

### Implementação

**demo/main.sh:**

```bash
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source "$LIB_DIR/logger.sh"
source "$LIB_DIR/color.sh"

# Função exibida ao listar comandos da categoria
show_complement_help() {
    echo ""
    log_output "${LIGHT_GREEN}Opções da categoria demo:${NC}"
    log_output "  -h, --help       Mostra esta mensagem de ajuda"
    log_output "  --list           Lista todos os comandos demo disponíveis"
    log_output "  --about          Informações sobre o plugin Hello World"
}

# Main
main() {
    case "${1:-}" in
        -h|--help) show_complement_help; exit 0 ;;
        --list) list_demo_commands; exit 0 ;;
        --about) show_about; exit 0 ;;
        *) log_error "Opção desconhecida: $1"; exit 1 ;;
    esac
}

# IMPORTANTE: Permite controle de execução
if [ "${SUSA_SKIP_MAIN:-}" != "1" ]; then
    main "$@"
fi
```

### Quando Usar

**✅ Bons casos de uso:**

- Operações em massa (--upgrade-all, --list-all)
- Ações que afetam múltiplos comandos da categoria
- Help complementar com informações da categoria

**❌ Evite usar para:**

- Comandos individuais (use comandos normais)
- Lógica complexa que deveria ser um comando próprio

> **📖 Documentação completa:** Veja [Categorias com Parâmetros](https://duducp.github.io/susa/guides/subcategories/#categorias-com-parametros-feature-avancada) para mais detalhes.

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
- `minha-categoria/category.json` - Nome e descrição da categoria
- `minha-categoria/meu-comando/command.json` - Configuração do comando
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
2. **Configuração JSON**: Defina metadados e comportamento dos comandos
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
