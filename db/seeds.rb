professor_types = %w[Efetivo Temporário]
professor_types.each do |category|
  ProfessorType.find_or_create_by!(name: category)
end

professor_roles = [
  { name: 'Professor Responsável', identifier: 'responsible' },
  { name: 'Professor de TCC 1', identifier: 'tcc_one' }
]

professor_roles.each do |role|
  Role.find_or_create_by!(name: role[:name], identifier: role[:identifier]) if Role.all.empty?
end

scholarity = [
  { name: 'Ensino médio completo', abbr: 'Ensino m.' },
  { name: 'Graduado', abbr: 'Grad.' },
  { name: 'Especialista', abbr: 'Esp.' },
  { name: 'Mestre', abbr: 'Me.' },
  { name: 'Doutor', abbr: 'Dr.' },
  { name: 'Doutora', abbr: 'Dra.' }
]

scholarity.each do |title|
  Scholarity.find_or_create_by!(name: title[:name], abbr: title[:abbr]) if Scholarity.all.empty?
end

professor_responsible = Professor.create_with(
  name: 'Diego Marczal',
  email: 'responsavel@email.com',
  gender: 'M',
  lattes: 'https://www.lattes.com/marczal',
  scholarity_id: Scholarity.pluck(:id).sample,
  professor_type_id: ProfessorType.pluck(:id).sample,
  working_area: 'Desenvolvimento web',
  is_active: true,
  available_advisor: false,
  password: '123456'
).find_or_create_by!(username: 'marczal')

professor_responsible.roles << Role.first if professor_responsible.roles.empty?

base_activity_types = [
  'Envio de documento',
  'Envio de documento com assinatura',
  'Informativa'
]

base_activity_types.each do |base_activity_type|
  BaseActivityType.find_or_create_by!(name: base_activity_type) if BaseActivity.all.empty?
end
