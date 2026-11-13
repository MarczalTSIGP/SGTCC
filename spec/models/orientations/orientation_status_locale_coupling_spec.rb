require 'rails_helper'

# O enum de status monta as chaves a partir de I18n.t no carregamento da classe, então
# `orientation.status` devolve o rótulo traduzido. Comparar esse retorno com um literal
# em português acopla regra de negócio ao locale e falha em silêncio se ele mudar.
#
# Uma verificação em tempo de execução não distingue os dois casos: o enum já foi montado
# quando o exemplo roda, então trocar `I18n.locale` não muda o valor de `status`. Por isso
# a garantia aqui é sobre o código-fonte dos consumidores.
RSpec.describe Orientation do
  let(:status_labels) do
    I18n.t('enums.orientation.status').except(:select).values
  end

  let(:consumers) do
    [
      'app/models/orientation.rb',
      'app/presenters/dashboard/responsible_presenter.rb',
      'app/presenters/dashboard/professor_presenter.rb',
      'app/components/orientations/status_badge_component.rb'
    ]
  end

  it 'compares status through the enum API instead of translated literals' do
    offenders = consumers.filter_map do |path|
      source = Rails.root.join(path).read
      found = status_labels.select do |label|
        source.include?("'#{label}'") || source.include?("\"#{label}\"")
      end

      "#{path}: #{found.join(', ')}" if found.any?
    end

    expect(offenders).to be_empty
  end
end
