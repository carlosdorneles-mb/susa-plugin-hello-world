# Guia de Desenvolvimento de Plugins

Este documento complementa o README.md com informações técnicas sobre desenvolvimento de plugins.

## 📐 Estrutura Recomendada

### Mínima (1 comando)

```text
meu-plugin/
├── README.md
├── plugin.json
└── categoria/
    ├── category.json
    └── comando/
        ├── command.json
        └── main.sh
```

### Completa (múltiplos comandos + .env)

```text
meu-plugin/
├── README.md
├── plugin.json
├── LICENSE
├── .gitignore
└── categoria/
    ├── category.json
    ├── comando1/
    │   ├── command.json
    │   ├── main.sh
    │   ├── .env.example
    │   └── .gitignore     # Ignorar .env local
    └── comando2/
        ├── command.json
        └── main.sh
```

## 🔧 Configuração Detalhada

### category.json da Categoria

**Categoria simples (navegável):**

```json
{
  "name": "Nome da Categoria",
  "description": "Descrição breve da categoria"
}
```

**Categoria com entrypoint (aceita parâmetros):**

```json
{
  "name": "Demo",
  "description": "Comandos de demonstração e exemplos",
  "entrypoint": "main.sh"
}
```

**Campos:**

- `name`: Nome exibido no help (opcional)
- `description`: Descrição da categoria (obrigatório)
- `entrypoint`: Script da categoria que aceita parâmetros (opcional, feature avançada)

> **ℹ️ Importante:** Quando uma categoria tem `entrypoint`, ela pode aceitar parâmetros diretamente. Veja seção "Categoria com Entrypoint" abaixo.

### command.json do Comando

```json
{
  "name": "Nome do Comando",
  "description": "Descrição breve do comando",
  "entrypoint": "main.sh",
  "sudo": false,
  "os": ["linux", "mac"],
  "env_files": [".env", ".env.local"],
  "envs": {
    "VAR1": "valor1",
    "VAR2": "valor2",
    "VAR_PATH": "$HOME/.config"
  }
}
```

**Campos obrigatórios:**

- `name`: Nome do comando
- `description`: Descrição do comando
- `entrypoint`: Script principal (geralmente `main.sh`)
- `sudo`: Requer privilégios de root? (`true`/`false`)
- `os`: Lista de sistemas operacionais (`linux`, `mac`, `windows`)

**Campos opcionais:**

- `env_files`: Lista de arquivos .env a carregar
- `envs`: Variáveis de ambiente do comando
- `group`: Grupo para organização (string)

## 🌍 Variáveis de Ambiente

### Ordem de Precedência

1. **Sistema** - `export VAR=value` ou `VAR=value susa comando`
2. **Config envs** - `command.json → envs:`
3. **Global** - `config/settings.conf`
4. **Arquivos .env** - Na ordem de `env_files:`
5. **Padrão no script** - `${VAR:-default}`

### Exemplo Prático

**command.json:**

```json
{
  "env_files": [".env"],
  "envs": {
    "API_URL": "https://api.example.com",
    "TIMEOUT": "30"
  }
}
```

**.env:**

```bash
DATABASE_URL="postgresql://localhost/mydb"
DEBUG_MODE="false"
```

**main.sh:**

```bash
#!/bin/bash
set -euo pipefail

# Usar variáveis com fallback
api_url="${API_URL:-https://default.com}"
timeout="${TIMEOUT:-10}"
database="${DATABASE_URL:-sqlite:///local.db}"

echo "API: $api_url"
echo "Timeout: $timeout"
echo "Database: $database"
```

## 📚 Bibliotecas Disponíveis

Seu plugin tem acesso às bibliotecas do Susa CLI.

> **📖 Documentação Completa:** Para ver todas as bibliotecas disponíveis e suas funções detalhadas, consulte a [Referência de Bibliotecas](https://duducp.github.io/susa/reference/libraries/) na documentação oficial.

**Exemplos das principais bibliotecas:**

### Logger (`logger.sh`)

```bash
log_info "Mensagem informativa"
log_success "Operação concluída!"
log_warning "Atenção!"
log_error "Erro ocorrido!"
log_debug "Debug (visível apenas com DEBUG=true)"
```

### Colors (`color.sh`)

```bash
echo -e "${GREEN}Texto verde${NC}"
echo -e "${RED}Texto vermelho${NC}"
echo -e "${YELLOW}Texto amarelo${NC}"
echo -e "${BLUE}Texto azul${NC}"
```

**Variáveis disponíveis:**

- `GREEN`, `RED`, `YELLOW`, `BLUE`, `PURPLE`, `CYAN`
- `LIGHT_GREEN`, `LIGHT_RED`, etc.
- `GRAY`, `LIGHT_GRAY`
- `NC` (No Color) - para resetar

### String (`string.sh`)

```bash
# Verificar se string contém substring
if string_contains "texto completo" "completo"; then
    echo "Contém!"
fi

# Verificar se string começa com prefixo
if string_starts_with "hello world" "hello"; then
    echo "Começa com hello"
fi

# Converter para lowercase/uppercase
lowercase=$(string_to_lower "TEXTO")
uppercase=$(string_to_upper "texto")

# Remover espaços em branco
trimmed=$(string_trim "  texto  ")
```

### OS Detection (`os.sh`)

```bash
# Detectar sistema operacional
if is_linux; then
    echo "Rodando em Linux"
fi

if is_mac; then
    echo "Rodando em macOS"
fi

# Obter nome do OS
os_name=$(get_simple_os)  # Retorna: linux, mac, windows
```

### Dependencies (`dependencies.sh`)

```bash
# Verificar se comando existe
if command_exists "docker"; then
    echo "Docker instalado"
fi

# Verificar múltiplas dependências
if check_dependencies "git" "curl" "jq"; then
    echo "Todas dependências instaladas"
fi
```

### Help System

```bash
# Exibir descrição do comando
show_description

# Exibir uso básico
show_usage "[opções]"
```

## 🧪 Testando Seu Plugin

### Teste Local (Modo Desenvolvimento)

```bash
# 1. Instalar plugin localmente em modo desenvolvimento
susa self plugin add /caminho/completo/para/seu-plugin
# Ou do diretório do plugin:
cd seu-plugin
susa self plugin add .

# 2. Testar comando
susa sua-categoria seu-comando

# 3. Fazer alterações no código
vim sua-categoria/seu-comando/main.sh

# 4. Testar novamente - mudanças refletem automaticamente!
susa sua-categoria seu-comando

# 5. Verificar com debug (modo verbose)
susa sua-categoria seu-comando -v

# 6. Ver ajuda
susa sua-categoria seu-comando --help
```

**Vantagem do Modo Dev:** Plugins instalados localmente refletem alterações automaticamente. Não é necessário reinstalar após cada modificação no código!

### Verificar Instalação

```bash
# Listar plugins
susa self plugin list

# Ver informações do plugin
ls -la "$HOME/.local/share/susa/plugins/seu-plugin"
```

### Remover para Reinstalar

```bash
# Remover
susa self plugin remove seu-plugin

# Reinstalar
susa self plugin add /caminho/seu-plugin
```

## 🎨 Categoria com Entrypoint (Feature Avançada)

Categorias podem ter um `entrypoint` que permite aceitar parâmetros diretamente, sem precisar criar comandos individuais. Isso é útil para operações em massa ou ações que afetam todos os comandos da categoria.

### Quando Usar

**✅ Bons casos de uso:**

- Operações em massa (--upgrade-all, --list-all)
- Ações que afetam múltiplos comandos da categoria
- Parâmetros comuns que se aplicam a toda categoria
- Help complementar com informações da categoria

**❌ Evite usar para:**

- Comandos individuais (use comandos normais)
- Lógica complexa que deveria ser um comando próprio
- Categorias que são apenas contêineres de navegação

### Estrutura

```text
demo/
├── category.json        # ← Com campo entrypoint
├── main.sh              # ← Script da categoria
├── hello/
│   ├── command.json
│   └── main.sh
└── info/
    ├── command.json
    └── main.sh
```

### Configuração

**demo/category.json:**

```json
{
  "name": "Demo",
  "description": "Comandos de demonstração e exemplos",
  "entrypoint": "main.sh"
}
```

### Implementação do Script

**demo/main.sh:**

```bash
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Source libraries
source "$LIB_DIR/logger.sh"
source "$LIB_DIR/color.sh"

# Show complement help (exibida ao final da listagem de comandos)
show_complement_help() {
    echo ""
    log_output "${LIGHT_GREEN}Opções da categoria:${NC}"
    log_output "  --list           Lista todos os comandos disponíveis"
    log_output "  --about          Informações sobre o plugin"
    echo ""
}

# Lista comandos demo disponíveis
list_demo_commands() {
    local lock_file="$CLI_DIR/susa.lock"

    log_info "Comandos demo disponíveis:"

    local commands=$(jq -r '.commands[]? | select(.category == "demo") |
                           "\(.name)\t\(.description // "Sem descrição")"' "$lock_file" 2> /dev/null)

    if [ -n "$commands" ]; then
        echo "$commands"
    else
        log_warning "Nenhum comando demo encontrado"
    fi
}

# Informações sobre o plugin
show_about() {
    echo ""
    log_output "${LIGHT_CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
    log_output "${LIGHT_CYAN}║           Hello World Plugin - Demo                  ║${NC}"
    log_output "${LIGHT_CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    log_output "${LIGHT_GREEN}Sobre:${NC}"
    log_output "  Plugin de exemplo que demonstra como criar plugins para o Susa CLI"
    echo ""
    log_output "${LIGHT_GREEN}Recursos demonstrados:${NC}"
    log_output "  • Comandos simples e interativos"
    log_output "  • Categorias com entrypoint e parâmetros"
    log_output "  • Uso de bibliotecas do Susa (logger, color, etc)"
    log_output "  • Estrutura de plugin completa"
    echo ""
}

# Main function
main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --list)
                list_demo_commands
                exit 0
                ;;
            --about)
                show_about
                exit 0
                ;;
            *)
                log_error "Opção desconhecida: $1"
                echo ""
                log_output "Use ${LIGHT_CYAN}susa demo --help${NC} para ver as opções"
                exit 1
                ;;
        esac
    done
}

# Execute main (controlado por SUSA_SKIP_MAIN)
if [ "${SUSA_SKIP_MAIN:-}" != "1" ]; then
    main "$@"
fi
```

### Importante sobre `SUSA_SKIP_MAIN`

A variável `SUSA_SKIP_MAIN` é usada pelo sistema para evitar execução do `main` quando apenas quer chamar `show_complement_help`:

```bash
# Sempre adicione esta condição no final do script
if [ "${SUSA_SKIP_MAIN:-}" != "1" ]; then
    main "$@"
fi
```

Isso permite que o sistema:

1. Execute o script normalmente quando o usuário passa parâmetros
2. Apenas source o script e chame `show_complement_help()` ao listar comandos

### Comportamento

- **Sem argumentos** (`susa demo`): Lista comandos + mostra help complementar
- **Com argumentos** (`susa demo --list`): Executa script da categoria
- **Comando específico** (`susa demo hello`): Executa comando normalmente

### Testando

```bash
# Lista comandos + mostra help complementar
susa demo

# Executa ação da categoria
susa demo --list
susa demo --about

# Comando específico funciona normalmente
susa demo hello
```

## 📝 Boas Práticas

### 1. Sempre use `set -euo pipefail`

```bash
#!/bin/bash
set -euo pipefail
```

Isso garante:

- `-e`: Para em erros
- `-u`: Erro em variáveis não definidas
- `-o pipefail`: Falha se qualquer comando em pipe falhar

### 2. Use valores padrão nas variáveis

```bash
# ✅ Bom
timeout="${TIMEOUT:-30}"

# ❌ Ruim
timeout="$TIMEOUT"  # Falha se TIMEOUT não existir
```

### 3. Valide argumentos

```bash
if [ -z "${2:-}" ]; then
    log_error "Argumento obrigatório não fornecido"
    show_usage
    exit 1
fi
```

### 4. Forneça ajuda clara

```bash
show_help() {
    show_description
    echo ""
    show_usage "[opções]"
    echo ""
    echo -e "${LIGHT_GREEN}Opções:${NC}"
    echo "  -h, --help    Exibe ajuda"
    echo ""
    echo -e "${LIGHT_GREEN}Exemplos:${NC}"
    echo "  susa categoria comando"
}
```

### 5. Use .env para configurações sensíveis

**.gitignore:**

```gitignore
.env
.env.local
.env.*.local
```

**.env.example:**

```bash
# Copie para .env e customize
API_KEY="sua-chave-aqui"
DATABASE_PASSWORD="sua-senha"
```

### 6. Mantenha qualidade de código

Use as ferramentas de verificação incluídas:

```bash
# Verificar código antes de commit
make check

# Formatar código automaticamente
make format

# Instalar hooks de pre-commit
make install
```

## 🔍 Ferramentas de Qualidade

### ShellCheck

Verifica erros comuns em scripts shell:

```bash
# Verificar um arquivo
shellcheck demo/hello/main.sh

# Verificar todos os scripts
find . -name "*.sh" | xargs shellcheck
```

### shfmt

Formata código shell de forma consistente:

```bash
# Verificar formatação
shfmt -i 4 -d demo/hello/main.sh

# Formatar automaticamente
shfmt -i 4 -w demo/hello/main.sh
```

### pre-commit

Executa verificações automaticamente antes de cada commit:

```bash
# Instalar hooks
pre-commit install

# Executar manualmente
pre-commit run --all-files

# Atualizar hooks
pre-commit autoupdate
```

### Configuração do Editor

#### VS Code

1. Instale extensões:
   - ShellCheck (`timonwong.shellcheck`)
   - Shell Format (`foxundermoon.shell-format`)

2. Configure `.vscode/settings.json`:

```json
{
  "shellcheck.enable": true,
  "shellformat.flag": "-i 4",
  "[shellscript]": {
    "editor.defaultFormatter": "foxundermoon.shell-format",
    "editor.formatOnSave": true
  }
}
```

#### Vim/Neovim

```vim
" ALE para shellcheck
let g:ale_linters = {'sh': ['shellcheck']}
let g:ale_fixers = {'sh': ['shfmt']}
let g:ale_sh_shfmt_options = '-i 4'
```

## 🔍 Troubleshooting

### Comando não aparece

```bash
# Verificar estrutura
ls -la "$HOME/.local/share/susa/plugins/seu-plugin"

# Recriar cache
rm -f "$CLI_DIR/susa.lock"
susa self lock
```

### Variáveis não carregam

```bash
# Testar com debug
DEBUG=true susa categoria comando

# Verificar se command.json está correto
cat "/.local/share/susa/plugins/seu-plugin/categoria/comando/command.json"
```

### Erro ao executar

```bash
# Verificar permissões
chmod +x "$HOME/.local/share/susa/plugins/seu-plugin/categoria/comando/main.sh"

# Testar sintaxe
bash -n "$HOME/.local/share/susa/plugins/seu-plugin/categoria/comando/main.sh"
```

## 📖 Referências

- [Documentação Oficial](https://duducp.github.io/susa)
- [Guia de Comandos](https://duducp.github.io/susa/guides/adding-commands/)
- [Sistema de Plugins](https://duducp.github.io/susa/plugins/overview/)
- [Variáveis de Ambiente](https://duducp.github.io/susa/guides/envs/)
