# Makefile for Susa plugin development

.PHONY: help install-dev format lint test clean pre-commit

# Cores para output
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
RED := \033[0;31m
NC := \033[0m

help:
	@echo "$(GREEN)Susa Plugin - Makefile Commands$(NC)"
	@echo ""
	@echo "$(BLUE)Development Commands:$(NC)"
	@grep -E '^(install-dev):.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\\n", $$1, $$2}'
	@echo ""
	@echo "$(BLUE)Quality Assurance Commands:$(NC)"
	@grep -E '^(format|lint|test|pre-commit):.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\\n", $$1, $$2}'
	@echo ""
	@echo "$(BLUE)Utility Commands:$(NC)"
	@grep -E '^clean:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\\n", $$1, $$2}'
	@echo ""

install-dev: ## Instala ferramentas de desenvolvimento
	@echo "$(GREEN)📦 Instalando ferramentas de desenvolvimento...$(NC)"
	@echo ""

	@# Instalar shellcheck
	@if ! command -v shellcheck >/dev/null 2>&1; then \
		echo "$(BLUE)  → Instalando shellcheck...$(NC)"; \
		if [ "$$(uname)" = "Darwin" ]; then \
			if command -v brew >/dev/null 2>&1; then \
				brew install shellcheck; \
			else \
				echo "$(RED)    ❌ Homebrew não encontrado. Instale em: https://brew.sh$(NC)"; \
				exit 1; \
			fi \
		else \
			sudo apt install -y shellcheck; \
		fi; \
		echo "$(GREEN)    ✅ shellcheck instalado!$(NC)"; \
	else \
		echo "$(GREEN)  ✓ shellcheck já instalado$(NC)"; \
	fi

	@# Instalar shfmt
	@if ! command -v shfmt >/dev/null 2>&1; then \
		echo "$(BLUE)  → Instalando shfmt...$(NC)"; \
		if [ "$$(uname)" = "Darwin" ]; then \
			if command -v brew >/dev/null 2>&1; then \
				brew install shfmt; \
			else \
				echo "$(RED)    ❌ Homebrew não encontrado. Instale em: https://brew.sh$(NC)"; \
				exit 1; \
			fi \
		else \
			sudo apt install -y shfmt; \
		fi; \
		echo "$(GREEN)    ✅ shfmt instalado!$(NC)"; \
	else \
		echo "$(GREEN)  ✓ shfmt já instalado$(NC)"; \
	fi

	@# Usar pip3 ou pip, com preferência para --user
	@PIP_CMD=$$(command -v pip3 || command -v pip); \
	if [ -n "$$PIP_CMD" ]; then \
		echo "$(BLUE)  → Instalando ferramentas Python...$(NC)"; \
		$$PIP_CMD install --user --upgrade pip 2>/dev/null || $$PIP_CMD install --upgrade pip; \
		$$PIP_CMD install --user pre-commit yamllint 2>/dev/null || $$PIP_CMD install pre-commit yamllint; \
		echo "$(GREEN)    ✅ pre-commit e yamllint instalados!$(NC)"; \
	else \
		echo "$(RED)❌ pip não está disponível. Instale Python/pip primeiro.$(NC)"; \
		exit 1; \
	fi

	@# Instalar hooks do pre-commit
	@if command -v pre-commit >/dev/null 2>&1; then \
		echo "$(BLUE)  → Configurando hooks do pre-commit...$(NC)"; \
		pre-commit install; \
		echo "$(GREEN)    ✅ Hooks instalados!$(NC)"; \
	fi

	@echo ""
	@echo "$(GREEN)✅ Ferramentas de desenvolvimento instaladas com sucesso!$(NC)"

lint: ## Executa ShellCheck, shfmt e yamllint em todos os arquivos
	@if find . -name "*.sh" -not -path "./.git/*" -not -path "./.pre-commit-cache/*" | xargs shellcheck -x; then \
		echo "$(GREEN)✅ Todos os scripts passaram na verificação do ShellCheck!$(NC)"; \
	else \
		echo "$(RED)❌ Alguns scripts falharam na verificação do ShellCheck$(NC)"; \
		exit 1; \
	fi

	@if find . -name "*.sh" -not -path "./.git/*" -not -path "./.pre-commit-cache/*" | xargs shfmt -d -i 4 -ci -sr; then \
		echo "$(GREEN)✅ Todos os scripts passaram na verificação de formatação do shfmt!$(NC)"; \
	else \
		echo "$(RED)❌ Alguns scripts falharam na verificação de formatação do shfmt$(NC)"; \
		echo "$(YELLOW)💡 Execute 'make format' para corrigir$(NC)"; \
		exit 1; \
	fi

	@if yamllint .; then \
		echo "$(GREEN)✅ Todos os arquivos YAML passaram na verificação!$(NC)"; \
	else \
		echo "$(RED)❌ Alguns arquivos YAML falharam na verificação$(NC)"; \
		exit 1; \
	fi

format: ## Formata automaticamente todos os scripts com shfmt
	@echo "$(GREEN)✨ Formatando scripts com shfmt...$(NC)"
	@command -v shfmt >/dev/null 2>&1 || { echo "$(RED)❌ shfmt não está instalado. Execute 'make install-dev'$(NC)"; exit 1; }
	@find . -name "*.sh" -not -path "./.git/*" -not -path "./.pre-commit-cache/*" | xargs shfmt -w -i 4 -ci -sr
	@echo "$(GREEN)✅ Scripts formatados com sucesso!$(NC)"

pre-commit: ## Executa pre-commit em todos os arquivos
	@echo "$(BLUE)🔍 Executando pre-commit...$(NC)"
	@command -v pre-commit >/dev/null 2>&1 || { echo "$(RED)❌ pre-commit não está instalado. Execute 'make install-dev'$(NC)"; exit 1; }
	@pre-commit run --all-files --show-diff-on-failure
	@echo "$(GREEN)✅ Pre-commit concluído!$(NC)"

test: ## Executa todos os testes
	@echo "$(GREEN)✅ Todos os testes passaram!$(NC)"

clean: ## Remove arquivos temporários
	@echo "$(YELLOW)🧹 Limpando arquivos temporários...$(NC)"
	@find . -name "*~" -delete 2>/dev/null || true
	@find . -name "*.bak" -delete 2>/dev/null || true
	@rm -rf .pre-commit-cache/ 2>/dev/null || true
	@echo "$(GREEN)✅ Limpeza concluída!$(NC)"
