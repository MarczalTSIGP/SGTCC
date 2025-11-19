require 'json'

namespace :sgtcc do
  desc "Assina somente TCO baseado no arquivo data/tco_signatures.json (com rollback)"
  task sign_tco_from_json: :environment do
    ActiveRecord::Base.transaction do
      begin
        puts "\n✍️ Iniciando assinatura de TCOs com base no JSON..."

        file = File.read(Rails.root.join("lib/data/tco_signatures.json"))
        orientations = JSON.parse(file)["orientations"]

        TCO_ID = 1
        OBS_TEXT = "Este é um documento digital, gerado e assinado automaticamente pelo SGTCC, referente a um documento físico que se encontra na coordenação de TSI. No momento da assinatura do documento físico, o SGTCC não existia, assim esta medida foi adotada para manter o histórico de documentos digitais no SGTCC."

        signed_count = 0
        skipped_count = 0
        missing_count = 0

        orientations.each do |item|
          title = item["title"]
          orientation = Orientation.find_by(title: title)

          if orientation.nil?
            puts "⚠️  Orientação NÃO encontrada: #{title}"
            missing_count += 1
            next
          end

          signatures = orientation.signatures
                                  .joins(:document)
                                  .where(status: false)
                                  .where(documents: { document_type_id: TCO_ID })
                                  .includes(:document)

          if signatures.empty?
            puts "ℹ️  Nenhum TCO pendente para: #{title}"
            skipped_count += 1
            next
          end

          signatures.each do |signature|
            document = signature.document

            # Adiciona observação caso não exista
            document.content["document"]["obs"] ||= OBS_TEXT
            document.save!

            # Assina o documento
            signature.sign

            signed_count += 1
            puts "✅ TCO assinado para: #{title} (documento #{document.id})"
          end
        end # <-- FIM do loop orientations.each

        # Agora, fora do loop, imprime o resumo final
        puts "\n📊 Resumo:"
        puts "   ✅ TCOs assinados: #{signed_count}"
        puts "   ↩️ Já estavam assinados / ignorados: #{skipped_count}"
        puts "   ❗ Não encontrados no banco: #{missing_count}"

        puts "\n🎉 Processo concluído com sucesso!"

      rescue => e
        puts "\n❌ ERRO durante execução: #{e.message}"
        puts "↩️ Rollback acionado. Nenhuma assinatura foi salva."
        raise ActiveRecord::Rollback
      end
    end
  end
end
