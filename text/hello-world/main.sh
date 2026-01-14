#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Help function
show_help() {
    show_description
    echo ""
    show_usage
    echo ""
    echo -e "${LIGHT_GREEN}Descrição:${NC}"
    echo "  Exibe informações detalhadas sobre a instalação da CLI Susa,"
    echo "  incluindo versão, caminhos, status de completação e dependências."
    echo ""
    echo -e "${LIGHT_GREEN}Opções:${NC}"
    echo "  -h, --help        Exibe esta mensagem de ajuda"
    echo "  -v, --verbose     Habilita saída detalhada para depuração"
    echo "  -q, --quiet       Minimiza a saída, desabilita mensagens de depuração"
    echo ""
    echo -e "${LIGHT_GREEN}Exemplos:${NC}"
    echo "  susa setup hello-world                # Exibe todas as informações da CLI"
    echo "  susa setup hello-world --help         # Exibe esta ajuda"
    echo ""
}


# Hello function
func_hello_world() {
    log_info "Executando func_hello_world..."
    log_debug "Variável de ambiente ENABLED carregada: ${ENABLED:-not set}"
    
    # Adicione a lógica da função aqui
}


# Main function
main() {
    local action="hello_world"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--verbose)
                export DEBUG=true
                log_debug "Modo verbose ativado"
                shift
                ;;
            -q|--quiet)
                export SILENT=true
                shift
                ;;
            *)
                log_error "Opção desconhecida: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    # Execute action
    log_debug "Ação selecionada: $action"

    case "$action" in
        hello_world)
            func_hello_world
            ;;
        *)
            log_error "Ação desconhecida: $action"
            exit 1
            ;;
    esac
}

# Execute main function
main "$@"