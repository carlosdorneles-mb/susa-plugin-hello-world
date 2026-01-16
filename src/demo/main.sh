#!/usr/bin/env zsh
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
