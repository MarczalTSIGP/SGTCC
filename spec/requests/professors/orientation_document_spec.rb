require 'rails_helper'

# `GET /professors/orientations/:id/documents/:document_id` não definia `@signatures`, como
# fazem as ações equivalentes das outras áreas, e a view quebrava com HTTP 500.
RSpec.describe 'Professor orientation document' do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:document) { orientation.documents.first }

  before { login_as(professor, scope: :professor) }

  it 'has a document created with the orientation' do
    expect(document).to be_present
  end

  it 'shows a document of the advisor orientation' do
    get professors_orientation_document_path(orientation, document)

    expect(response).to have_http_status(:ok)
  end

  it 'does not offer the sign button on this page' do
    get professors_orientation_document_path(orientation, document)

    expect(response.body).not_to include(professors_document_sign_path(document))
  end
end
