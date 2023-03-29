professor_types = %w[Efetivo Temporário]
professor_types.each do |category|
  ProfessorType.find_or_create_by!(name: category)
end

professor_roles = [
  { name: 'Professor Responsável', identifier: 'responsible' },
  { name: 'Professor de TCC 1', identifier: 'tcc_one' },
  { name: 'Coordenador do Curso', identifier: 'coordinator' }
]

professor_roles.each do |role|
  Role.create_with(name: role[:name]).find_or_create_by!(identifier: role[:identifier])
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
  Scholarity.find_or_create_by!(name: title[:name], abbr: title[:abbr])
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
  { name: 'Envio de documento', identifier: :send_document },
  { name: 'Informativa', identifier: :info }
]

base_activity_types.each do |base_activity_type|
  BaseActivityType.find_or_create_by!(name: base_activity_type[:name],
                                      identifier: base_activity_type[:identifier])
end

document_types = [
  { name: I18n.t('signatures.documents.TCO'), identifier: DocumentType.identifiers[:tco] },
  { name: I18n.t('signatures.documents.TDO'), identifier: DocumentType.identifiers[:tdo] },
  { name: I18n.t('signatures.documents.TCAI'), identifier: DocumentType.identifiers[:tcai] },
  { name: I18n.t('signatures.documents.TEP'), identifier: DocumentType.identifiers[:tep] },
  { name: I18n.t('signatures.documents.TSO'), identifier: DocumentType.identifiers[:tso] },
  { name: I18n.t('signatures.documents.ADPP'), identifier: DocumentType.identifiers[:adpp] },
  { name: I18n.t('signatures.documents.ADPJ'), identifier: DocumentType.identifiers[:adpj] },
  { name: I18n.t('signatures.documents.ADMG'), identifier: DocumentType.identifiers[:admg] }
]

document_types.each do |document_type|
  DocumentType.find_or_create_by!(
    name: document_type[:name], identifier: document_type[:identifier]
  )
end

Site.find_or_create_by!(title: 'Site do TCC')

pages = [
  { menu_title: 'O TCC', fa_icon: 'fas fa-home', url: 'o-tcc', content: '### O TCC' },
  { menu_title: 'Professores', fa_icon: 'fas fa-chalkboard-teacher', url: 'professores' },
  { menu_title: 'Calendário', fa_icon: 'far fa-calendar-alt', url: 'calendario', content: '# O TCC' },
  { menu_title: 'Bancas de TCC', fa_icon: 'fas fa-file-signature', url: 'bancas-de-tcc' },
  { menu_title: 'TCCs aprovados', fa_icon: 'fas fa-file-code', url: 'tccs-aprovados' },
  { menu_title: 'TCCs aprovados em TCC 1', fa_icon: 'far fa-file-code', url: 'tccs-aprovados-em-tcc-um' },
  { menu_title: 'TCCs em TCC 1', fa_icon: 'far fa-file-code', url: 'tccs-em-tcc-um' },
  { menu_title: 'Documentos', fa_icon: 'fas fa-book', url: 'documentos', content: '### Documentos referentes ao TCC de TSI' },
  { menu_title: 'Ajuda', fa_icon: 'far fa-question-circle', url: 'ajuda', content: 'Eventuais dúvidas devem ser esclarecidas com o **Prof. Diego Marczal**, responsável pelo TCC do curso de TSI da UTFPR câmpus Guarapuava.' }
]

pages.each do |page|
  Page.find_or_create_by!(menu_title: page[:menu_title], fa_icon: page[:fa_icon],
                          url: page[:url],
                          content: page[:content] ? page[:content] : '.',
                          publish: true)
end
