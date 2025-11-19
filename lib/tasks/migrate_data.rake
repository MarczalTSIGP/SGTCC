namespace :migrate do
  desc "Executa o script de migração de dados dentro de uma transação"
  task data: :environment do
    ActiveRecord::Base.transaction do
      begin
        puts "🔄 [#{Time.now}] Iniciando migração de dados..."
        load Rails.root.join("lib", "tasks", "run_all_orientations.rb")
        puts "✅ [#{Time.now}] Migração concluída com sucesso!"
      rescue => e
        puts "❌ [#{Time.now}] Erro durante a migração: #{e.class} - #{e.message}"
        puts e.backtrace.take(3)
        puts "↩️ Revertendo todas as alterações (rollback)..."
        raise ActiveRecord::Rollback
      end
    end
  end
end
