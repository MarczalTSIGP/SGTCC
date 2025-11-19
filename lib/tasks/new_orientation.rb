# lib/tasks/create_orientations.rb
require 'json'

puts "📦 Iniciando Etapa 1/2: Criação e Configuração de Orientações..."

path = Rails.root.join('lib/data/orientation.json')
data = JSON.parse(File.read(path))

data['orientations'].each do |row|
  puts "---"
  puts "🔹 Processando CRIAÇÃO da orientação: #{row['title']}"

  # --- Busca de Dependências ---
  academic = Academic.find_by(ra: row['academic_ra'])
  unless academic
    puts "❌ Acadêmico RA #{row['academic_ra']} não encontrado"
    next
  end

  advisor = Professor.find_by(email: row['professor_email'])
  unless advisor
    puts "❌ Professor #{row['professor_email']} não encontrado"
    next
  end

  calendar_data = row['calendar']
  calendar = Calendar.find_by(
    year: calendar_data['year'],
    semester: calendar_data['semester'],
    tcc: calendar_data['tcc']
  )
  unless calendar
    puts "❌ Calendário #{calendar_data.inspect} não encontrado"
    next
  end

  # Cria ou busca Orientação
  orientation = Orientation.find_or_initialize_by(
    title: row['title'],
    academic: academic,
    advisor: advisor
  )
 
  # --- Configuração de Dados ---
  if row['institution'].present? && row['institution']['cnpj'].present?
    cnpj_norm = row['institution']['cnpj'].to_s.gsub(/\D/, '')

    institution = Institution.where("regexp_replace(cnpj, '\\D', '', 'g') = ?", cnpj_norm).first

    if institution
      orientation.institution = institution
      puts "🔎 Instituição associada: #{institution.name} (CNPJ: #{institution.cnpj})"
    end
  end

  orientation.created_at = row['created_at'].present? ? DateTime.parse(row['created_at']) : Time.current
  orientation.updated_at = row['updated_at'].present? ? DateTime.parse(row['updated_at']) : Time.current
  orientation.status = Orientation.statuses['Aprovada em TCC 1'] if orientation.status.nil?
  orientation.calendar_ids = [calendar.id]
  
  if row['supervisors'].present?
    supervisor_ids = Professor.where(email: row['supervisors']).pluck(:id)
    orientation.professor_supervisor_ids = supervisor_ids
    puts "👥 Coorientadores vinculados: #{row['supervisors'].join(', ')}"
  else
    puts "ℹ️ Nenhum coorientador informado."
  end
  
  # PERSISTE a orientação, disparando a criação do Termo de Compromisso e Assinaturas (after_create_commit)
  orientation.save!(validate: false)
  
  puts "   ✅ Orientação configurada e salva. ID: #{orientation.id}"
end

puts "\n🎉 Etapa 1/2 (Criação) finalizada! Prossiga para o script de assinatura."