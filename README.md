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
susa self plugin install https://github.com/duducp/susa-plugin-hello-world.git
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

### Testando o Plugin

Durante o desenvolvimento, você pode testar o plugin localmente sem precisar instalá-lo primeiro. O Susa CLI oferece o comando `self plugin run` que permite executar plugins em **modo de desenvolvimento**.

#### Modo Automático (Recomendado)

Para testes rápidos, use o modo automático que adiciona o plugin temporariamente, executa o comando e faz cleanup automaticamente:

```bash
# Execute do diretório raiz do plugin
cd susa-plugin-hello-world
susa self plugin run susa-plugin-hello-world text hello-world

# Passar argumentos para o comando
susa self plugin run susa-plugin-hello-world text hello-world -- --help
```

O plugin é automaticamente:

1. Adicionado ao registry temporariamente
2. Executado
3. Removido do registry após execução

#### Modo Manual (Testes Múltiplos)

Para testes mais elaborados onde você precisa executar múltiplos comandos sem reinstalar:

```bash
# 1. Preparar plugin dev (adicionar ao registry)
cd susa-plugin-hello-world
susa self plugin run --prepare susa-plugin-hello-world text hello-world

# 2. Executar comandos normalmente (múltiplas vezes)
susa text hello-world
susa text hello-world --help

# 3. Limpar plugin dev (remover do registry)
susa self plugin run --cleanup susa-plugin-hello-world text hello-world
```

#### Separador de Argumentos

Use `--` para separar opções do comando `run` de argumentos do plugin:

```bash
# --help vai para o plugin (não para o comando run)
susa self plugin run susa-plugin-hello-world text hello-world -- --help

# Múltiplos argumentos após o separador
susa self plugin run susa-plugin-hello-world text hello-world -- --verbose --dry-run
```

#### Debug com Verbose

```bash
# Verbose do run (mostra busca e preparação interna)
susa self plugin run -v susa-plugin-hello-world text hello-world

# Verbose do plugin (usa separador --)
susa self plugin run susa-plugin-hello-world text hello-world -- -v
```

Isso permite testar suas mudanças rapidamente durante o desenvolvimento sem precisar instalar e reinstalar o plugin a cada modificação.

Para maiores informações consulte a documentação do comando [run](https://duducp.github.io/susa/reference/commands/self/plugins/run/) e a documentação de [plugins](https://duducp.github.io/susa/plugins/overview/).

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
