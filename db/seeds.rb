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
  { menu_title: 'Calendário', fa_icon: 'far fa-calendar-alt', url: 'calendario',
    content: '# O TCC' },
  { menu_title: 'Bancas de TCC', fa_icon: 'fas fa-file-signature', url: 'bancas-de-tcc' },
  { menu_title: 'TCCs aprovados', fa_icon: 'fas fa-file-code', url: 'tccs-aprovados' },
  { menu_title: 'TCCs aprovados em TCC 1', fa_icon: 'far fa-file-code',
    url: 'tccs-aprovados-em-tcc-um' },
  { menu_title: 'TCCs em TCC 1', fa_icon: 'far fa-file-code', url: 'tccs-em-tcc-um' },
  { menu_title: 'Documentos', fa_icon: 'fas fa-book', url: 'documentos',
    content: '### Documentos referentes ao TCC de TSI' },
  { menu_title: 'Ajuda', fa_icon: 'far fa-question-circle', url: 'ajuda',
    content: 'Eventuais dúvidas devem ser esclarecidas com o **Prof. Diego Marczal**,
    responsável pelo TCC do curso de TSI da UTFPR câmpus Guarapuava.' }
]

pages.each do |page|
  Page.find_or_create_by!(menu_title: page[:menu_title], fa_icon: page[:fa_icon],
                          url: page[:url],
                          content: page[:content] || '.',
                          publish: true)
end

templates = [
  {
    title: 'Documento pendente de assinatura',
    key: 'document_pending_signature',
    channel: 'email',
    subject: 'Assinatura pendente no documento %<document_type>s!',
    body: 'O documento %<document_type>s, criado em %<created_at>s, ainda não foi assinado.
    <br> Sua assinatura é necessária para dar continuidade ao processo.',
    notification_rule_attributes: { max_retries: 30, hours_after: 24 }
  },
  {
    title: 'Assinatura pendente da Ata de Defesa',
    key: 'document_ad_signature_pending',
    channel: 'email',
    subject: 'Assinatura pendente da Ata de Defesa',
    body: 'A Ata de Defesa referente ao TCC %<orientation>s precisa ser assinada com urgência.
    <br> O prazo de assinatura é reduzido devido à relevância do documento.',
    notification_rule_attributes: { hours_after: 2, max_retries: 30, retry_interval_hours: 2 }
  },
  {
    title: 'Lembrete de prazo acadêmico',
    key: 'academic_deadline_upcoming',
    channel: 'email',
    subject: 'Lembrete de prazo para a atividade %<activity_title>s',
    body: 'O prazo final para %<activity_title>s é %<final_date>s.
    <br> Faltam %<days_left>s para o encerramento. Não deixe para a última hora!',
    notification_rule_attributes: { extra_notes: 'DailyDeadLineJob' }
  },
  {
    title: 'Lembrete de prazo para orientadores',
    key: 'professor_deadline_upcoming',
    channel: 'email',
    subject: 'Lembrete de prazo para as atividades de seu(s) orientando(s)',
    body: '
    O prazo final para %<activity_title>s de seus orientandos é %<final_date>s.
    <br> Faltam %<days_left>s dias para o encerramento.
    Acompanhe o progresso no sistema para evitar atrasos.',
    notification_rule_attributes: { extra_notes: 'DailyDeadLineJob' }
  },
  {
    title: 'Documento enviado pelo acadêmico',
    key: 'document_uploaded',
    channel: 'email',
    subject: 'Novo %<academic_activity_title>s por %<academic_name>s',
    body: 'O aluno %<academic_name>s concluiu a atividade
     %<academic_activity_title>s em %<submission_date>s.
    <br> O documento já está disponível para avaliação.',
    notification_rule_attributes: { hours_before: 0 }
  },
  {
    title: 'Documento atualizado pelo acadêmico',
    key: 'document_updated',
    channel: 'email',
    subject: 'Atualização de envio de %<academic_activity_title>s por %<academic_name>s',
    body: '
    O aluno %<academic_name>s atualizou a atividade %<academic_activity_title>s em %<submission_date>s.
    <br> A nova versão já está disponível no sistema para avaliação.',
    notification_rule_attributes: { hours_before: 0 }
  },
  {
    title: 'Designação para banca de avaliação',
    key: 'atendees_examination_board_assigned',
    channel: 'email',
    subject: 'Agendamento de banca para avaliação',
    body: '
    Você foi designado como avaliador na banca do aluno %<academic_name>s,
    com TCC intitulado %<orientation_title>s.
    <br> Data: %<date>s
    <br> Horário: %<time>s
    <br> Local: %<place>s
    <br> Por favor, confirme sua disponibilidade.',
    notification_rule_attributes: { hours_after: 1, max_retries: 2, retry_interval_hours: 48 }
  },
  {
    title: 'Confirmação de banca de avaliação',
    key: 'atendee_confirmed_examination_board',
    channel: 'email',
    subject: 'Agendamento de banca confirmado',
    body: '
    A banca de avaliação do aluno %<academic_name>s,
    com TCC intitulado %<orientation_title>s,
     foi confirmada com os seguintes detalhes:
    <br> Data: %<date>s
    <br> Horário: %<time>s
    <br> Local: %<place>s
    <br> Acesse o sistema para mais detalhes.',
    notification_rule_attributes: { extra_notes: 'Envio único' }
  },
  {
    title: 'Banca de avaliação agendada',
    key: 'academic_confirmed_examination_board',
    channel: 'email',
    subject: 'Agendamento de banca confirmado',
    body: '
    Olá %<academic_name>s, a banca de defesa do seu TCC com os seguintes detalhes foi confirmada:
    <br> Data: %<date>s
    <br> Horário: %<time>s
    <br> Local: %<place>s
    <br> Acesse o sistema para mais detalhes.',
    notification_rule_attributes: { extra_notes: 'Envio único' }
  },
  {
    title: 'Apontamentos da banca disponíveis',
    key: 'academic_examination_board_appointments',
    channel: 'email',
    subject: 'Apontamentos da banca disponíveis',
    body: '
    Os apontamentos registrados pela banca do seu TCC, realizada no dia %<date>s, já estão disponíveis no sistema.
    <br> Acesse sua área para consultá-los.',
    notification_rule_attributes: { extra_notes: 'Envio único' }
  },
  {
    title: 'Submissão de termo registrada',
    key: 'term_submission',
    channel: 'email',
    subject: 'Submissão de %<document_type>s registrada',
    body: '
    Foi registrado um %<document_type>s para o TCC %<orientation>s
     do aluno %<academic_name>s orientado por %<advisor_name>s.
    <br> Verifique os detalhes no sistema.',
    notification_rule_attributes: { extra_notes: 'Envio único' }
  },
  {
    title: 'Ciência de participação em reunião',
    key: 'meeting_participation_acknowledgment',
    channel: 'email',
    subject: 'Registro de reunião disponível',
    body: '
    Seu orientador, %<advisor_name>s, registrou uma reunião no sistema.
    <br> Por favor, confirme a ciência das informações acessando sua área no SGTCC.',
    notification_rule_attributes: { max_retries: 30, retry_interval_hours: 48 }
  },
  {
    title: 'Criação de atividade no calendário acadêmico',
    key: 'activity_calendar_created',
    channel: 'email',
    subject: 'Criação de nova atividade no calendário para TCC %<tcc_type>s em %<year>s/%<semester>s',
    body: '
    Uma nova atividade foi criada no calendário acadêmico de TCC %<tcc_type>s em %<year>s/%<semester>s.
    <br> A atividade %<activity_name>s foi cadastrada em %<created_at>s.
    <br> Por favor, consulte o sistema para verificar as atividades atualizadas.',
    notification_rule_attributes: { hours_after: 1, extra_notes: 'Envio único' }
  },
  {
    title: 'Atualização de atividade no calendário acadêmico',
    key: 'activity_calendar_updated',
    channel: 'email',
    subject: 'Atualização de atividade no calendário para TCC %<tcc_type>s em %<year>s/%<semester>s',
    body: '
    Uma atividade foi atualizada no calendário acadêmico de TCC %<tcc_type>s em %<year>s/%<semester>s.
    <br> A atividade %<activity_name>s foi atualizada em %<updated_at>s.
    <br> Por favor, consulte o sistema para verificar as atividades atualizadas.',
    notification_rule_attributes: { hours_after: 1, extra_notes: 'Envio único' }
  }
]

templates.each do |attrs|
  NotificationTemplate.find_or_create_by!(title: attrs[:title], key: attrs[:key],
                                          channel: attrs[:channel],
                                          subject: attrs[:subject],
                                          body: attrs[:body]) do |template|
    template.build_notification_rule(attrs[:notification_rule_attributes])
  end
end
