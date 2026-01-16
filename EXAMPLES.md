# Exemplos de Estruturas de Plugins

Este documento mostra diferentes estruturas de plugins do mais simples ao mais complexo.

## 1. Plugin Simples (1 Comando)

```text
meu-plugin/
├── README.md
├── plugin.json
└── utils/
    ├── category.json
    └── greet/
        ├── command.json
        └── main.sh
```

**Uso:** `susa utils greet`

## 2. Plugin com Múltiplos Comandos

```text
meu-plugin/
├── README.md
├── plugin.json
└── tools/
    ├── category.json
    ├── backup/
    │   ├── command.json
    │   └── main.sh
    ├── restore/
    │   ├── command.json
    │   └── main.sh
    └── clean/
        ├── command.json
        └── main.sh
```

**Uso:**

- `susa tools backup`
- `susa tools restore`
- `susa tools clean`

## 3. Plugin com Subcategorias

```text
meu-plugin/
├── README.md
├── plugin.json
└── deploy/
    ├── category.json
    ├── staging/
    │   ├── category.json
    │   ├── app/
    │   │   ├── command.json
    │   │   └── main.sh
    │   └── db/
    │       ├── command.json
    │       └── main.sh
    └── production/
        ├── command.json
        ├── app/
        │   ├── command.json
        │   └── main.sh
        └── db/
            ├── command.json
            └── main.sh
```

**Uso:**

- `susa deploy staging app`
- `susa deploy staging db`
- `susa deploy production app`
- `susa deploy production db`

## 4. Plugin com Múltiplas Categorias

```text
meu-plugin/
├── README.md
├── plugin.json
├── backup/
│   ├── category.json
│   ├── create/
│   │   ├── command.json
│   │   └── main.sh
│   └── list/
│       ├── command.json
│       └── main.sh
└── monitor/
    ├── category.json
    ├── status/
    │   ├── command.json
    │   └── main.sh
    └── logs/
        ├── command.json
        └── main.sh
```

**Uso:**

- `susa backup create`
- `susa backup list`
- `susa monitor status`
- `susa monitor logs`

## 5. Plugin Completo (com .env e scripts auxiliares)

```text
meu-plugin/
├── README.md
├── DEVELOPMENT.md
├── LICENSE
├── .gitignore
├── plugin.json
├── scripts/
│   └── install.sh
└── api/
    ├── category.json
    ├── common.sh          # Funções compartilhadas
    ├── get/
    │   ├── command.json
    │   ├── main.sh
    │   ├── .env.example
    │   └── .gitignore
    ├── post/
    │   ├── command.json
    │   ├── main.sh
    │   ├── .env.example
    │   └── .gitignore
    └── delete/
        ├── command.json
        ├── main.sh
        ├── .env.example
        └── .gitignore
```

**Estrutura de arquivos:**

**api/common.sh:**

```bash
#!/bin/bash

# Função compartilhada entre comandos
api_call() {
    local method="$1"
    local endpoint="$2"
    local api_url="${API_BASE_URL:-https://api.example.com}"

    curl -X "$method" "$api_url/$endpoint"
}
```

**api/get/main.sh:**

```bash
#!/bin/bash
set -euo pipefail

# Carregar funções comuns
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"

main() {
    local endpoint="${1:-users}"
    api_call "GET" "$endpoint"
}

main "$@"
```

## 6. Plugin com Categoria que Aceita Parâmetros (Feature Avançada)

Categorias podem ter um `entrypoint` que permite aceitar parâmetros diretamente:

```text
meu-plugin/
├── README.md
├── plugin.json
└── demo/
    ├── category.json         # Com campo entrypoint
    ├── main.sh               # Script da categoria
    ├── hello/
    │   ├── command.json
    │   └── main.sh
    └── info/
        ├── command.json
        └── main.sh
```

**demo/category.json:**

```json
{
  "name": "Demo",
  "description": "Comandos de demonstração",
  "entrypoint": "main.sh"
}
```

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
    log_output "${LIGHT_GREEN}Opções da categoria:${NC}"
    log_output "  --list           Lista comandos disponíveis"
    log_output "  --about          Informações sobre o plugin"
}

# Lista comandos
list_demo_commands() {
    local lock_file="$CLI_DIR/susa.lock"
    local commands=$(jq -r '.commands[]? | select(.category == "demo") | "\(.name)|\(.description)"' "$lock_file" 2>/dev/null)

    echo "$commands" | while IFS='|' read -r name desc; do
        printf "  %-20s %s\n" "$name" "$desc"
    done
}

# Main
main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --list)
                list_demo_commands
                exit 0
                ;;
            --about)
                echo "Sobre o plugin..."
                exit 0
                ;;
            *)
                log_error "Opção desconhecida: $1"
                exit 1
                ;;
        esac
    done
}

# IMPORTANTE: Permite controle de execução do main
if [ "${SUSA_SKIP_MAIN:-}" != "1" ]; then
    main "$@"
fi
```

**Uso:**

- `susa demo` → Lista comandos + mostra help complementar
- `susa demo --list` → Lista comandos da categoria
- `susa demo --about` → Informações do plugin
- `susa demo hello` → Executa comando específico

**Quando usar:**

- ✅ Operações em massa (--upgrade-all, --list-all)
- ✅ Ações que afetam toda a categoria
- ✅ Help complementar com informações extras
- ❌ Comandos individuais (use comandos normais)

## 7. Template Recomendado

Para começar um novo plugin, use esta estrutura:

```text
meu-plugin/
├── README.md                 # Documentação principal
├── plugin.json               # Config de plugin
├── DEVELOPMENT.md            # Guia de desenvolvimento
├── LICENSE                   # Licença do projeto
├── .gitignore                # Arquivos a ignorar
│
└── categoria/                # Sua categoria principal
    ├── category.json         # Config da categoria
    │
    ├── comando1/             # Primeiro comando
    │   ├── command.json      # Config do comando
    │   ├── main.sh           # Script principal
    │   ├── .env.example      # Exemplo de .env
    │   └── .gitignore        # Ignorar .env local
    │
    └── comando2/             # Segundo comando
        ├── command.json
        ├── main.sh
        ├── .env.example
        └── .gitignore
```

## Dicas de Organização

### Quando usar subcategorias?

Use subcategorias quando tiver comandos que se relacionam hierarquicamente:

✅ **Bom uso:**

```text
deploy/
  ├── staging/
  │   ├── app/
  │   └── db/
  └── production/
      ├── app/
      └── db/
```

❌ **Evite:**

```text
commands/
  ├── deploy-staging-app/
  ├── deploy-staging-db/
  ├── deploy-production-app/
  └── deploy-production-db/
```

### Compartilhar código entre comandos

**Opção 1: Script comum na categoria**

```text
categoria/
├── common.sh          # Funções compartilhadas
├── comando1/
│   └── main.sh        # source ../common.sh
└── comando2/
    └── main.sh        # source ../common.sh
```

**Opção 2: Biblioteca no plugin**

```text
plugin/
├── lib/
│   ├── api.sh
│   └── utils.sh
└── categoria/
    ├── comando1/
    │   └── main.sh    # source ../../lib/api.sh
    └── comando2/
        └── main.sh    # source ../../lib/api.sh
```

### Variáveis de ambiente por nível

**Global do plugin** (categoria/category.json):

```json
{
  "envs": {
    "PLUGIN_VERSION": "1.0.0",
    "PLUGIN_DEBUG": "false"
  }
}
```

**Específico do comando** (categoria/comando/command.json):

```json
{
  "envs": {
    "API_ENDPOINT": "https://api.example.com",
    "TIMEOUT": "30"
  }
}
```

**Local via .env** (categoria/comando/.env):

```bash
API_KEY="sua-chave-local"
DATABASE_URL="postgresql://localhost/mydb"
```

## Recursos Adicionais

- [Documentação Oficial](https://duducp.github.io/susa)
- [Plugin de Exemplo](https://github.com/duducp/susa-plugin-hello-world)
- [Sistema de Plugins](https://duducp.github.io/susa/plugins/overview/)
