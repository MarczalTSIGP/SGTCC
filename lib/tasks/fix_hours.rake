namespace :fix_hours_examination_boards do
  desc "Atualiza a hora da banca a partir de um JSON"
  task update_hour: :environment do
    require 'json'

    file_path = Rails.root.join('lib', 'data', 'hours.json')
    json = JSON.parse(File.read(file_path))

    json["orientations"].each do |item|
      ra    = item["ra"]
      title = item["title"]
      identifier = item["identifier"]
      new_date   = item["new_date"]

      puts "\nProcessando RA: #{ra}"

      academic = Academic.find_by(ra: ra)
      if academic.nil?
        puts "Aluno não encontrado na tabela academixs"
        next
      end 

      orientation = Orientation.find_by(
        academic_id: academic.id,
        title: title
      )

      if orientation.nil?
        puts "→ Orientação não encontrada"
        next
      end

      puts "→ orientation_id: #{orientation.id}"

      board = ExaminationBoard.find_by(
        orientation_id: orientation.id,
        identifier: identifier
      )

      if board.nil?
        puts "→ Banca não encontrada (identifier: #{identifier})"
        next
      end

      puts "→ Data antiga: #{board.date}"

      board.update!(date: new_date)

      puts "✅ Data atualizada para: #{board.reload.date}"
    end
  end
end
