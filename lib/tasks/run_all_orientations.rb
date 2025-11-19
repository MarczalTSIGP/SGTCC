puts "📦 Iniciando importação completa..."

# Executa o script de orientações
puts "📖 Importando orientações..."
load File.expand_path('new_orientation.rb', __dir__)
load File.expand_path('sign_documents.rb', __dir__)

# Executa o script de atas de defesa
puts "📑 Importando atas de defesa..."
load File.expand_path('proposal.rb', __dir__)

# Executa o script de atas de defesa
puts "📑 Importando atas de defesa..."
load File.expand_path('project.rb', __dir__)

# Executa o script de atas de monografia
puts "📑 Importando atas de defesa..."
load File.expand_path('new_ata_monograph.rb', __dir__)

puts "🎉 Importação completa finalizada!"

# docker exec -it sgtcc-web-1 bash
# rails runner run_all_orientations.rb