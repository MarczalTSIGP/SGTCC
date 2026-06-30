require 'rails_helper'

RSpec.describe Professor do
  subject(:professor) { described_class.new }

  describe '#documents_signed' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }
    let(:distinct_query) { 'DISTINCT ON (documents.id) documents.*' }

    before do
      orientation.signatures.find_by(user_type: :advisor).sign
    end

    it 'returns the signed documents' do
      conditions = { user_id: professor.id, user_type: 'AD', status: true }
      documents = Document.joins(:signatures).select(distinct_query).where(signatures: conditions)
      expect(professor.documents_signed).to match_array(documents)
    end
  end

  describe '#documents_pending' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }
    let(:distinct_query) { 'DISTINCT ON (documents.id) documents.*' }

    it 'returns the pending documents' do
      conditions = { user_id: professor.id, user_type: 'AD', status: false }
      documents = Document.joins(:signatures)
                          .select(distinct_query)
                          .where(signatures: conditions, request: nil)
      expect(professor.documents_pending).to match_array(documents)
    end
  end

  describe '#documents_reviewing' do
    let!(:orientation) { create(:orientation) }
    let!(:professor) { orientation.advisor }

    before do
      create(:document_tdo, orientation_id: orientation.id)
    end

    it 'returns the reviewing documents' do
      data = professor.documents.with_relationships.where.not(request: nil)
      data = data.select do |document|
        document.send("#{document.document_type.identifier}_for_review?")
      end
      expect(professor.documents_reviewing).to match_array(data)
    end
  end

  describe '#documents_request' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }
    let(:document_tdo) { create(:document_tdo, orientation_id: orientation.id) }
    let(:distinct_query) { 'DISTINCT ON (documents.id) documents.*' }

    it 'returns the reviewing documents' do
      conditions = { user_id: professor.id, user_type: 'AD', status: false }
      documents = Document.joins(:signatures)
                          .select(distinct_query)
                          .where(signatures: conditions)
                          .where(document_types: { identifier: :tdo })
                          .where.not(request: nil)
                          .with_relationships
      expect(professor.documents_request).to match_array(documents)
    end
  end
end
