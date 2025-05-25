# 📁 Sistema de Gerenciamento de Arquivos (Teste CLICKSIGN)

Este projeto é uma solução para o desafio técnico da CLICKSIGN. Ele implementa a camada de modelos de um sistema de gerenciamento de arquivos com suporte a diretórios aninhados e upload de arquivos utilizando ActiveStorage.

## 🧩 Funcionalidades
  - Criar diretórios e subdiretórios recursivamente.
  - Criar arquivos dentro de diretórios.
  - Upload de arquivos com conteúdo persistido via ActiveStorage.
  - Relacionamentos entre diretórios (pai/filho).
  - Validação de presença do nome dos diretórios.
  - Testes automatizados com RSpec.

## 🛠️ Tecnologias Utilizadas
  - Ruby 3.4.1
  - Rails 8.0.2
  - PostgreSQL
  - RSpec
  - Active Storage

## ▶️ Como executar localmente

```bash
# 1. Clone o repositório

# 2. Instale as dependências
bundle install

# 3. Configure o banco de dados
rails db:create db:migrate db:seed

# 4. Execute o servidor
rails server

## 🧪 Executando os testes
bundle exec rspec

## 📝 Observações
  - O projeto foi focado na camada de modelos, conforme exigido no teste.
  - Os arquivos são persistidos em disco local (pasta /storage) usando ActiveStorage::DiskService.
  - O sistema pode ser facilmente adaptado para persistir arquivos em S3, Azure Blob, etc.
