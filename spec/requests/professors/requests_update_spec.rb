require 'rails_helper'

# Troca de orientação em um TDO recria o documento. O documento antigo só pode ser apagado
# depois que o novo for salvo; antes, ele era apagado primeiro e um novo inválido deixava o
# professor sem nenhum dos dois.
RSpec.describe 'Professor TDO request update' do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:other_orientation) { create(:orientation, advisor: professor) }
  let!(:document) { create(:document_tdo, orientation_id: orientation.id) }

  before { login_as(professor, scope: :professor) }

  def submit(orientation_id:, justification:)
    patch professors_request_path(document),
          params: { document: { orientation_id:, justification: } }
  end

  it 'updates in place when only the justification changes' do
    expect { submit(orientation_id: orientation.id, justification: 'nova') }
      .not_to change(Document, :count)

    expect(document.reload.request['requester']['justification']).to eq('nova')
  end

  it 'replaces the document when the orientation changes' do
    submit(orientation_id: other_orientation.id, justification: 'nova')

    expect(Document.exists?(document.id)).to be(false)
    expect(response).to redirect_to(professors_document_path(Document.last))
  end

  context 'when the replacement is invalid' do
    before { submit(orientation_id: other_orientation.id, justification: '') }

    it 'keeps the original document' do
      expect(Document.exists?(document.id)).to be(true)
      expect(document.reload.request['requester']['justification']).not_to be_blank
    end

    it 'shows the form again with the error' do
      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'does not create another document' do
      expect(Document.where(document_type: document.document_type).count).to eq(1)
    end
  end
end
