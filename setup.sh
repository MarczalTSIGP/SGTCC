#!/bin/bash
set -e

echo "=== 🚀 Reiniciando instalação do SGTCC do zero ==="

# 0️⃣ Limpar containers, volumes e imagens antigas
echo "🔹 Limpando containers, volumes e imagens antigas..."
docker compose down -v
docker system prune -af

# 1️⃣ Construir as imagens sem cache
echo "🔹 Construindo imagens Docker sem cache..."
docker compose build --no-cache

# 2️⃣ Instalar dependências Ruby on Rails
echo "🔹 Instalando gems do Rails..."
docker compose run --rm web bundle install

# 3️⃣ Instalar dependências Javascript (Yarn) como root
echo "🔹 Instalando dependências JS com Yarn..."
docker compose run --rm --user root web bash -c "
  rm -rf node_modules yarn.lock 2>/dev/null || true
  yarn install
"

# 4️⃣ Configurar variáveis de ambiente
echo "🔹 Criando arquivo de configuração (application.yml)..."
cp -n config/application.yml.example config/application.yml || echo "Arquivo já existe, ignorando."

echo "❗ Lembre-se de editar config/application.yml para ajustar Mailtrap e outras variáveis."

# ✅ Garantir que a pasta de logs exista e tenha permissões corretas
echo "🔹 Criando pasta de logs e ajustando permissões..."
docker compose run --rm --user root web bash -c "
  mkdir -p log tmp/pids tmp/cache tmp/sockets &&
  chown -R rails:rails log tmp
"

# 5️⃣ Criar banco de dados
echo "🔹 Criando banco de dados..."
docker compose run --rm web bundle exec rails db:create

# 6️⃣ Executar migrações
echo "🔹 Executando migrações..."
docker compose run --rm web bundle exec rails db:migrate

# 7️⃣ Popular banco com seeds
echo "🔹 Popular banco com seeds..."
docker compose run --rm web bundle exec rails db:seed

# 8️⃣ Levantar os serviços em background
echo "🔹 Subindo container web em background..."
docker compose up -d web

# 9️⃣ Popular com registros fake
echo "🔹 Populando aplicação com dados fake..."
docker compose exec web bundle exec rails db:populate

echo "✅ Instalação completa! Acesse http://localhost:3000"
