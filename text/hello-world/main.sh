#!/bin/bash
set -euo pipefail

setup_command_env

# Help function
show_help() {
    show_description
    echo ""
    show_usage --no-options
    echo ""
    echo -e "${LIGHT_GREEN}Descrição:${NC}"
    echo "  Exibe informações detalhadas sobre a instalação da CLI Susa,"
    echo "  incluindo versão, caminhos, status de completação e dependências."
    echo ""
    echo -e "${LIGHT_GREEN}Opções:${NC}"
    echo "  -h, --help        Exibe esta mensagem de ajuda"
    echo ""
    echo -e "${LIGHT_GREEN}Exemplos:${NC}"
    echo "  susa setup hello-world                # Exibe todas as informações da CLI"
    echo "  susa setup hello-world --help         # Exibe esta ajuda"
    echo ""
}


# Main function
main() {
    echo "Hello World! This is a sample setup script."
}

# Parse arguments first, before running main
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
    shift
done

# Execute main function
main