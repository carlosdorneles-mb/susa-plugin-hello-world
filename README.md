# 🚀 Hello World - Susa Plugin

Um plugin de exemplo para o Susa CLI que demonstra a estrutura básica e as melhores práticas para desenvolvimento de plugins externos.

## 📋 Sobre

Este plugin serve como template e exemplo de referência para desenvolvedores que desejam criar seus próprios plugins para o Susa CLI. Ele implementa um comando simples que exibe "Hello World!" demonstrando:

- Estrutura de diretórios recomendada
- Configuração de comandos via YAML
- Implementação de scripts bash
- Sistema de ajuda integrado
- Tratamento de argumentos e opções

## ✨ Funcionalidades

- **Comando Hello World**: Exibe uma mensagem de saudação personalizada
- **Sistema de Ajuda**: Documentação integrada acessível via `--help`
- **Tratamento de Erros**: Validação de argumentos e mensagens de erro claras
- **Integração Completa**: Utiliza as funções e variáveis do ambiente Susa CLI

## 🔧 Instalação

### Instalação via Git

```bash
susa self plugin install https://github.com/carlosdorneles-mb/susa-plugin-hello-world.git
```

### Verificar Instalação

Após a instalação, verifique se o plugin está disponível:

```bash
susa text hello-world --help
```

## 📚 Uso

### Comando Básico

```bash
susa text hello-world
```

**Saída:**

```text
Hello World! This is a sample setup script.
```

### Exibir Ajuda

```bash
susa text hello-world --help
```

## 🗂️ Estrutura do Projeto

```text
susa-plugin-hello-world/
├── README.md                # Este arquivo
└── text/                    # Categoria do plugin
    ├── config.yaml          # Configuração da categoria
    └── hello-world/         # Comando hello-world
        ├── config.yaml      # Configuração do comando
        └── main.sh          # Script principal
```

### Arquivos de Configuração

#### `text/config.yaml`

Define a descrição da categoria principal do plugin:

```yaml
description: "Exemplo de plugin externo"
```

#### `text/hello-world/config.yaml`

Define a descrição e o arquivo principal do comando específico:

```yaml
name: "ASDF"
description: "Mostra a versão do Susa CLI"
script: "main.sh"
sudo: false
group:
os: ["linux", "mac"]
```

### Remover o Plugin

```bash
susa self plugin remove susa-plugin-hello-world
```

### Atualizar o Plugin

```bash
susa self plugin update susa-plugin-hello-world
```

### Listar Plugins Instalados

```bash
susa self plugin list
```

## 🎓 Desenvolvimento de Plugins

Este plugin serve como base para criar seus próprios plugins. Principais conceitos:

1. **Categorias**: Organize comandos relacionados sob uma categoria comum
2. **Configuração YAML**: Defina metadados e comportamento dos comandos
3. **Scripts Bash**: Implemente a lógica dos comandos
4. **Funções do Susa**: Utilize funções auxiliares como `setup_command_env`, `show_help`, `log_error`

### Variáveis de Ambiente Disponíveis

Ao executar scripts dentro do Susa CLI, você tem acesso as bibliotecas listadas [aqui](https://carlosdorneles-mb.github.io/susa/reference/libraries/).

## 📖 Recursos Adicionais

- **Documentação Oficial**: [Visão Geral de Plugins](https://carlosdorneles-mb.github.io/susa/plugins/overview/)
- **API de Plugins**: Guias detalhados sobre desenvolvimento
- **Exemplos**: Mais exemplos de plugins na organização

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:

1. Fazer fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abrir um Pull Request
