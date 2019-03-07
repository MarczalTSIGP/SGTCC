professor_types = %w[Efetivo Temporário]
professor_types.each do |category|
  ProfessorType.find_or_create_by!(name: category)
end

professor_roles = [
  'Professor orientador',
  'Professor coorientador',
  'Professor de TCC 1'
]

professor_roles.each do |role|
  ProfessorRole.find_or_create_by!(name: role)
end

professor_titles = [
  { name: 'Especialista', abbr: 'Esp.' },
  { name: 'Mestre', abbr: 'Me.' },
  { name: 'Doutor', abbr: 'Dr.' }
]

professor_titles.each do |title|
  ProfessorTitle.find_or_create_by!(name: title[:name], abbr: title[:abbr])
end

Professor.create_with(
  name: 'Diego Marczal',
  username: 'marczal',
  gender: 'M',
  lattes: 'https://www.lattes.com/marczal',
  professor_title_id: ProfessorTitle.last.id,
  professor_type_id: ProfessorType.first.id,
  professor_role_id: ProfessorRole.first.id,
  working_area: 'Desenvolvimento web',
  is_active: true,
  available_advisor: false,
  password: '123456'
).find_or_create_by!(email: 'responsavel@email.com')
