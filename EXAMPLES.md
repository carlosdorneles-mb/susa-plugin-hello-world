# Exemplos de Estruturas de Plugins

Este documento mostra diferentes estruturas de plugins do mais simples ao mais complexo.

## 1. Plugin Simples (1 Comando)

```text
meu-plugin/
├── README.md
└── utils/
    ├── config.yaml
    └── greet/
        ├── config.yaml
        └── main.sh
```

**Uso:** `susa utils greet`

## 2. Plugin com Múltiplos Comandos

```text
meu-plugin/
├── README.md
└── tools/
    ├── config.yaml
    ├── backup/
    │   ├── config.yaml
    │   └── main.sh
    ├── restore/
    │   ├── config.yaml
    │   └── main.sh
    └── clean/
        ├── config.yaml
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
└── deploy/
    ├── config.yaml
    ├── staging/
    │   ├── config.yaml
    │   ├── app/
    │   │   ├── config.yaml
    │   │   └── main.sh
    │   └── db/
    │       ├── config.yaml
    │       └── main.sh
    └── production/
        ├── config.yaml
        ├── app/
        │   ├── config.yaml
        │   └── main.sh
        └── db/
            ├── config.yaml
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
├── backup/
│   ├── config.yaml
│   ├── create/
│   │   ├── config.yaml
│   │   └── main.sh
│   └── list/
│       ├── config.yaml
│       └── main.sh
└── monitor/
    ├── config.yaml
    ├── status/
    │   ├── config.yaml
    │   └── main.sh
    └── logs/
        ├── config.yaml
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
├── scripts/
│   └── install.sh
└── api/
    ├── config.yaml
    ├── common.sh          # Funções compartilhadas
    ├── get/
    │   ├── config.yaml
    │   ├── main.sh
    │   ├── .env.example
    │   └── .gitignore
    ├── post/
    │   ├── config.yaml
    │   ├── main.sh
    │   ├── .env.example
    │   └── .gitignore
    └── delete/
        ├── config.yaml
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

## 6. Template Recomendado

Para começar um novo plugin, use esta estrutura:

```text
meu-plugin/
├── README.md                 # Documentação principal
├── DEVELOPMENT.md            # Guia de desenvolvimento
├── LICENSE                   # Licença do projeto
├── .gitignore                # Arquivos a ignorar
│
└── categoria/                # Sua categoria principal
    ├── config.yaml           # Config da categoria
    │
    ├── comando1/             # Primeiro comando
    │   ├── config.yaml       # Config do comando
    │   ├── main.sh           # Script principal
    │   ├── .env.example      # Exemplo de .env
    │   └── .gitignore        # Ignorar .env local
    │
    └── comando2/             # Segundo comando
        ├── config.yaml
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

**Global do plugin** (categoria/config.yaml):

```yaml
envs:
  PLUGIN_VERSION: "1.0.0"
  PLUGIN_DEBUG: "false"
```

**Específico do comando** (categoria/comando/config.yaml):

```yaml
envs:
  API_ENDPOINT: "https://api.example.com"
  TIMEOUT: "30"
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
