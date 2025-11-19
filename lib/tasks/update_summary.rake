namespace :academic_activities do
  desc "Atualiza somente summaries de atividades do tipo monografia com base em arquivo JSON dentro de uma transação"
  task update_summaries: :environment do
    require 'json'

    json_path = Rails.root.join("lib", "data", "summary.json")

    unless File.exist?(json_path)
      puts "Arquivo #{json_path} não encontrado!"
      next
    end

    summaries = JSON.parse(File.read(json_path), symbolize_names: true)

    if summaries.empty?
      puts "Nenhum resumo encontrado no JSON!"
      next
    end

    ActiveRecord::Base.transaction do
      begin
        summaries.each do |entry|
          academic_id = entry[:academic_id]
          new_summary = entry[:summary]

          puts ">>> Atualizando acadêmico #{academic_id}..."

          activities = AcademicActivity
                         .joins(:activity)
                         .where(
                           academic_id: academic_id,
                           activities: { identifier: :monograph }
                         )

          if activities.empty?
            puts "   Nenhuma monografia encontrada para esse aluno."
            next
          end

          activities.find_each do |activity|
            old = activity.summary
            activity.update!(summary: new_summary)
            puts "     Monografia #{activity.id} atualizada:"
            puts "     - Antes: #{old}"
            puts "     - Depois: #{new_summary}"
          end
        end
      rescue => e
        puts "Erro encontrado: #{e.message}. Todas as alterações serão revertidas."
        raise ActiveRecord::Rollback
      end
    end

    puts "\nAtualização finalizada!"
  end
end
