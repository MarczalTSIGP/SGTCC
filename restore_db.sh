#!/bin/bash

# --- Configuração ---
DB_USER="postgres"
DB_NAME="sgtcc_production"
SQL_FILE="db/structure3.sql"
# RAILS_MIGRATE_COMMAND="./run rails migrate:data"
# --------------------

echo "🛑 Derrubando e reconstruindo os serviços Docker (db e app)..."
docker compose down
docker compose up -d

echo "⏳ Aguardando alguns segundos para o banco de dados iniciar..."
sleep 5 # Dá tempo para o serviço 'db' inicializar

echo "🗑️ Conectando ao banco para recriar o schema: ${DB_NAME}"

# Comando para entrar no container 'db', rodar o psql, e recriar o banco
docker compose exec db psql -U ${DB_USER} -c "DROP DATABASE IF EXISTS ${DB_NAME};"
docker compose exec db psql -U ${DB_USER} -c "CREATE DATABASE ${DB_NAME};"

echo "✅ Banco de dados ${DB_NAME} recriado com sucesso."

# Restaura o schema (estrutura) do banco de dados
echo "⚙️ Restaurando estrutura do banco a partir de ${SQL_FILE}..."
# O uso do '-T' remove o modo pseudo-TTY, necessário ao redirecionar a entrada (<)
docker compose exec -T db psql -U ${DB_USER} -d ${DB_NAME} < ${SQL_FILE}

if [ $? -eq 0 ]; then
    echo "✅ Estrutura de dados restaurada com sucesso."
else
    echo "❌ Erro ao restaurar a estrutura do banco. Abortando a migração de dados."
    exit 1
fi

#  echo "🚀 Iniciando a migração de dados com o comando: ${RAILS_MIGRATE_COMMAND}"
# ${RAILS_MIGRATE_COMMAND}

# if [ $? -eq 0 ]; then
#     echo "🎉 Processo concluído com sucesso!"
# else
#     echo "⚠️ A migração de dados retornou um erro. Verifique o log acima."
# fi