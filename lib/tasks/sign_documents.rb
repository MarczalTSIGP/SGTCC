# lib/tasks/sign_documents.rb
require 'json'

puts "✍️ Iniciando Etapa 2/2: Assinatura dos Termos de Compromisso Pendentes..."

# IDs DOS DOCUMENTOS QUE SERÃO ASSINADOS:
# Verifique na sua tabela 'document_types' os IDs de 'tco' e 'tcai'
TCO_ID = 1  # Provavelmente 'Termo de Compromisso de Orientação...'
TCAI_ID = 3 # 'Termo de Compromisso e Aceite de Realização de TCC em Instituição'
DOCUMENT_IDS_TO_SIGN = [TCO_ID, TCAI_ID] 

OBS_TEXT = "Este é um documento digital, gerado e assinado automaticamente pelo SGTCC, referente a um documento físico que se encontra na coordenação de TSI. No momento da assinatura do documento físico, o SGTCC não existia, assim esta medida foi adotada para manter o histórico de documentos digitais no SGTCC."

# 1. Busca todas as assinaturas pendentes para os Termos
signatures_to_sign = Signature.joins(:document)
                              .where(status: false)
                              .where(documents: { document_type_id: DOCUMENT_IDS_TO_SIGN })
                              .includes(:document, :orientation) # Inclui a Orientação para pegar as datas

puts "   Encontradas #{signatures_to_sign.count} assinaturas pendentes para os documentos: #{DOCUMENT_IDS_TO_SIGN.join(', ')}."
puts "-------------------------------------------------------------------------------------------------------------------"

# 2. Itera sobre as assinaturas, atualiza as datas do documento e assina
signatures_to_sign.each do |signature|
  
  document = signature.document
  orientation = signature.orientation
  document_type_name = document.document_type.identifier.upcase

  # Pega as datas do JSON (que foram salvas na Orientação na Etapa 1)
  target_created_at = orientation.created_at
  target_updated_at = orientation.updated_at
  
  # --- ATUALIZAÇÃO DAS DATAS DO DOCUMENTO ---
  # Atualiza os timestamps do REGISTRO 'Document' (usando update_columns para evitar callbacks)
  document.update_columns(
    created_at: target_created_at,
    updated_at: target_updated_at
  )

  # Atualiza a data DENTRO do JSON 'content'
  document.content['document']['created_at'] = I18n.l(target_created_at, format: :document)
  
  # Adiciona o texto de observação se ainda não existir
  if document.content['document']['obs'].nil?
    document.content['document']['obs'] = OBS_TEXT
  end
  
  # Salva o JSON 'content' (usando 'save' normal para permitir atualizações do 'content')
  document.save!
  # --- FIM DA ATUALIZAÇÃO DE DATAS ---

  # Assina o documento
  signature.sign # O método 'sign' que usa update(status: true)
  
  puts "   ✍️ Assinatura ID #{signature.id} registrada para #{signature.user_type} - Documento: #{document_type_name}"
  puts "      -> Datas do Documento #{document.id} atualizadas para: #{target_created_at}"
end

puts "\n🎉 Etapa 2/2 (Assinatura e Atualização de Datas) finalizada!"