# lib/tasks/new_ata_monografia.rb
require 'json'

puts "📑 Criando/atualizando atas de monografia a partir do JSON..."

# Caminho do JSON
path = Rails.root.join('lib/data/orientation.json')
data = JSON.parse(File.read(path))

data['examination_boards'].select { |b| b['board_type'] == 'monograph' }.each do |board_data|
  academic_ra = board_data['academic_ra']
  board_type = 'monograph'

  # --- Buscar acadêmico ---
  academic = Academic.find_by(ra: academic_ra)
  raise "Acadêmico com RA #{academic_ra} não encontrado" unless academic

  # --- Buscar orientação ---
  orientation_data = data['orientations'].find do |o|
    o['academic_ra'] == board_data['academic_ra'] &&
    o['title'] == board_data['orientation_title']
  end
  raise "Orientação para RA #{academic_ra} não encontrada" unless orientation_data

  advisor = Professor.find_by(email: orientation_data['professor_email'])
  raise "Orientador #{orientation_data['professor_email']} não encontrado" unless advisor

  orientation = Orientation.find_by(title: orientation_data['title'], academic: academic, advisor: advisor)
  raise "Orientação '#{orientation_data['title']}' não encontrada" unless orientation

    # --- Verifica se a monografia foi cancelada ---
  if board_data['canceled'] == true
    justification = board_data['cancellation_justification'] || "Monografia cancelada via importação automática"

    # Atualiza o status da orientação para CANCELED
    orientation.update!(status: 'CANCELED', cancellation_justification: justification)

    puts "❌ Orientação cancelada para #{academic.name} - #{orientation.title} (monografia)"
    next # pula para o próximo registro sem criar banca, avaliadores ou documentos
  end

  migration_date_str = board_data['tcc2_migration_date']
  migration_date = migration_date_str.present? ? Date.parse(migration_date_str) : Date.today
  puts "📆 Migrando orientação para TCC 2 em #{migration_date}"

  # --- Associar calendário correto de TCC 2 baseado na data ---
  calendar = Calendar.find_by(
    tcc: 2,
    year: migration_date.year,
    semester: migration_date.month <= 6 ? 1 : 2 # semestre 1: jan-jun, semestre 2: jul-dez
  )

  if calendar.nil?
    puts "⚠️ Nenhum calendário encontrado para o TCC 2 no ano #{migration_date.year} e semestre #{migration_date.month <= 6 ? 1 : 2}"
  else
    # Associar calendário à orientação caso ainda não tenha
    unless orientation.calendars.include?(calendar)
      orientation.calendars << calendar
    end
  end

  orientation.save!

  # --- Criar/atualizar a banca ---
  board = ExaminationBoard.find_or_initialize_by(
    orientation: orientation,
    tcc: 2,                 # TCC 2 para monografia
    identifier: board_type
  )
  board.date = board_data['date']
  board.place = board_data['place']
  board.document_available_until = board_data['document_available_until']
  board.final_note = nil
  board.situation = 'approved'
  board.created_at = board.date
  board.updated_at = board.date
  board.save!

  puts "✅ Ata criada/atualizada para #{academic.name} - #{orientation.title} (monografia)"

  # --- Adiciona avaliadores internos ---
  if board_data['internal_evaluators']
    board_data['internal_evaluators'].each do |email|
      prof = Professor.find_by(email: email)
      next unless prof

      # Evita duplicar orientador ou coorientadores
       if prof.id == advisor.id || orientation.orientation_supervisors.map(&:professor_supervisor_id).compact.include?(prof.id)
        puts "⏭️ Ignorado #{prof.name} (orientador/coorientador)"
        next
      end

      ExaminationBoardAttendee.find_or_create_by!(
        examination_board: board,
        professor: prof
      )
      puts "   👤 Avaliador interno: #{prof.name}"
    end
  end

  # --- Adiciona avaliadores externos ---
  if board_data['external_evaluators']
    board_data['external_evaluators'].each do |email|
      member = ExternalMember.find_by(email: email)
      next unless member

      ExaminationBoardAttendee.find_or_create_by!(
        examination_board: board,
        external_member: member
      )
      puts "   👤 Avaliador externo: #{member.name}"
    end
  end

  # --- Cria o documento da defesa e assina automaticamente ---
  document = board.create_defense_minutes
  obs_text = "Este é um documento digital, gerado e assinado automaticamente pelo SGTCC, referente a um documento físico que se encontra na coordenação de TSI. No momento da assinatura do documento físico, o SGTCC não existia, assim esta medida foi adotada para manter o histórico de documentos digitais no SGTCC."

  target_created_at = board.created_at # (board.date)
  target_updated_at = board.updated_at # (board.date)
  
  content = document.content
  content['document']['created_at'] = I18n.l(target_created_at, format: :document)
  content['document']['obs'] = obs_text
  document.update_columns(
    created_at: target_created_at,
    updated_at: target_updated_at,
    content: content # Salva o JSON modificado
  )
  document.signatures.each(&:sign)
  puts "   ✍️ Documento assinado automaticamente por todos os participantes"

  # --- CIÊNCIA / ATIVIDADES ---
    
  # Caminho para a pasta do acadêmico
  academic_pdf_dir = Rails.root.join('lib', 'data', 'pdfs', academic.ra)

  # Caminho completo do PDF dentro da pasta do acadêmico
  pdf_path = academic_pdf_dir.join('monografia.pdf')


calendar.activities.each do |activity|
  # Só processa se o nome da activity contém "envio" (case-insensitive)
  next unless activity.name.downcase.include?("envio")

  aa = AcademicActivity.find_or_initialize_by(
    academic_id: academic.id,
    activity_id: activity.id
  )

  aa.judgment = true
  aa.title ||= orientation.title
  aa.summary ||= "Atividade de Monografia enviada automaticamente"

    if File.exist?(pdf_path)  
        work_type_code = "GP" # Ex: Tipo de Trabalho (Graduação, Projeto, etc.)
        course_name_code = "COINT" # Ex: Nome abreviado do Curso
        year_semester = "#{calendar.year}_#{calendar.semester}"
        # O nome do aluno já pode ser obtido do `orientation.academic.name`
        student_name_raw = orientation.academic.name # Ex: "Alexandre Karpinski Manikowski"
        document_type = "MONOGRAFIA" # Ex: Tipo de Atividade/Documento (Proposta, Versão Final)
        # --------------------------------

        # 1. Trata o nome do aluno: Translitera, substitui espaços por '_', e transforma em maiúsculas
        sanitized_student_name = I18n.transliterate(student_name_raw)
                                       .gsub(/\s+/, "_") # Substitui espaços por underline
                                       .gsub(/[^0-9A-Z_]/i, '') # Remove caracteres não alfanuméricos/underline
                                       .upcase

        # 2. Monta o novo nome do arquivo padronizado
        new_filename = [
            work_type_code, # GP
            course_name_code, # COINT
            year_semester, # 2017_2
            sanitized_student_name, # ALEXANDRE_KARPINSKI_MANIKOWSKI
            document_type # PROPOSTA
        ].join('_') + ".pdf" # Junta tudo com '_' e adiciona a extensão .pdf

        # Cria uma cópia temporária com o novo nome
        tmp_path = "/tmp/#{new_filename}"
        FileUtils.cp(pdf_path, tmp_path)

        # Associa o arquivo renomeado ao registro
        # Certifique-se de que 'aa' está definido e é o objeto correto
        aa.pdf = File.open(tmp_path)

        puts "✅ PDF anexado como #{new_filename}"
    else
        puts "⚠️ PDF não encontrado em: #{pdf_path}"
    end

  aa.save!
  puts "📘 Atividade registrada: #{activity.name} (ID #{aa.activity_id}) para #{academic.name}"
end

   # --- Atualiza status da orientação para concluída após a monografia ---
  orientation.update!(status: 'APPROVED')
  puts "🏁 Orientação #{orientation.title} marcada como concluída"
end

puts "🎉 Importação de atas de monografia finalizada!"
