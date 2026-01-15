#!/bin/bash
set -euo pipefail

# ============================================================
# Hello World Command
# Exemplo de comando de plugin para Susa CLI
# ============================================================

# Função de ajuda
show_help() {
    show_description
    echo ""
    show_usage "[opções]"
    echo ""
    echo -e "${LIGHT_GREEN}Descrição:${NC}"
    echo "  Exibe uma mensagem de saudação personalizada."
    echo "  Demonstra o uso de variáveis de ambiente e argumentos."
    echo ""
    echo -e "${LIGHT_GREEN}Opções:${NC}"
    echo "  -n, --name <nome>    Nome para a saudação (padrão: World)"
    echo "  -h, --help           Exibe esta mensagem de ajuda"
    echo ""
    echo -e "${LIGHT_GREEN}Variáveis de Ambiente:${NC}"
    echo "  HELLO_PREFIX         Prefixo da mensagem (padrão: 👋)"
    echo "  HELLO_MESSAGE        Mensagem customizada"
    echo "  HELLO_COLOR          Cor da mensagem (green, blue, yellow, red)"
    echo ""
    echo -e "${LIGHT_GREEN}Exemplos:${NC}"
    echo "  susa demo hello"
    echo "  susa demo hello --name \"João\""
    echo "  HELLO_COLOR=blue susa demo hello --name \"Maria\""
    echo ""
}

# Função principal do comando
hello_world() {
    local name="${1:-World}"

    # Carregar variáveis de ambiente (com valores padrão)
    local prefix="${HELLO_PREFIX:-👋}"
    local message="${HELLO_MESSAGE:-Hello}"
    local color="${HELLO_COLOR:-green}"

    # Log de debug (visível apenas com DEBUG=true)
    log_debug "Executando hello_world com nome: $name"
    log_debug "Prefix: $prefix, Message: $message, Color: $color"

    # Selecionar cor
    local color_code
    case "$color" in
        green) color_code="$GREEN" ;;
        blue) color_code="$BLUE" ;;
        yellow) color_code="$YELLOW" ;;
        red) color_code="$RED" ;;
        *) color_code="$GREEN" ;;
    esac

    # Exibir mensagem colorida
    echo ""
    echo -e "${color_code}${prefix} ${message}, ${name}!${NC}"
    echo ""

    # Informações adicionais
    log_success "Comando executado com sucesso!"
    log_info "Dica: Use --help para ver mais opções"
}

# Função principal
main() {
    local name="World"

    # Parse de argumentos
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h | --help)
                show_help
                exit 0
                ;;
            -n | --name)
                if [ -z "${2:-}" ]; then
                    log_error "Opção --name requer um argumento"
                    show_usage "[opções]"
                    exit 1
                fi
                name="$2"
                shift 2
                ;;
            *)
                log_error "Opção desconhecida: $1"
                echo ""
                show_usage "[opções]"
                exit 1
                ;;
        esac
    done

    # Executar comando
    hello_world "$name"
}

# Executar
main "$@"
