require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe Document do
  describe '#status_table' do
    let(:orientation) { create(:orientation) }
    let(:signature) { orientation.signatures.first }

    before do
      orientation.signatures << Signature.all
    end

    it 'returns the status table' do
      document = signature.document
      result = document.signatures.map do |signature|
        { name: signature.user.name, status: signature.status,
          role: I18n.t("signatures.users.roles.#{signature.user.gender}.#{signature.user_type}") }
      end
      document_status_table = document.status_table
      expect(document_status_table.first[:name]).to eq(result.first[:name])
      expect(document_status_table.first[:status]).to eq(result.first[:status])
    end
  end

  describe '#mark' do
    let(:orientation) { create(:orientation) }
    let(:document) { orientation.signatures.first.document }
    let(:signatures) { document.signatures }

    let(:professor_signature_signed) do
      signatures.where(user_type: :advisor).first
    end

    let(:supervisor_signature_signed) do
      signatures.where(user_type: :professor_supervisor).first
    end

    let(:academic_signature_signed) do
      signatures.where(user_type: :academic).first
    end

    let(:external_member_signature_signed) do
      signatures.where(user_type: :external_member_supervisor).first
    end

    let(:professor) { professor_signature_signed.user }
    let(:supervisor) { supervisor_signature_signed.user }
    let(:academic) { academic_signature_signed.user }
    let(:external_member) { external_member_signature_signed.user }

    let(:roles) do
      'signatures.users.roles'
    end

    let(:supervisor_role) do
      I18n.t("#{roles}.#{supervisor.gender}.#{supervisor_signature_signed.user_type}")
    end

    let(:external_member_role) do
      I18n.t("#{roles}.#{external_member.gender}.#{external_member_signature_signed.user_type}")
    end

    let(:academic_role) do
      I18n.t("#{roles}.#{academic.gender}.#{academic_signature_signed.user_type}")
    end

    let(:professor_role) do
      I18n.t("#{roles}.#{professor.gender}.#{professor_signature_signed.user_type}")
    end

    before do
      document.signatures.each { |s| s.update(status: true) }
    end

    it 'returns the signatures mark' do
      signatures_mark = [
        { name: supervisor.name,
          role: supervisor_role,
          date: I18n.l(supervisor_signature_signed.updated_at, format: :short),
          time: I18n.l(supervisor_signature_signed.updated_at, format: :time) },
        { name: external_member.name,
          role: external_member_role,
          date: I18n.l(external_member_signature_signed.updated_at, format: :short),
          time: I18n.l(external_member_signature_signed.updated_at, format: :time) },
        { name: academic.name,
          role: academic_role,
          date: I18n.l(academic_signature_signed.updated_at, format: :short),
          time: I18n.l(academic_signature_signed.updated_at, format: :time) },
        { name: professor.name,
          role: professor_role,
          date: I18n.l(professor_signature_signed.updated_at, format: :short),
          time: I18n.l(professor_signature_signed.updated_at, format: :time) }
      ]
      expect(document.mark).to match_array(signatures_mark)
    end
  end

  describe '#save_judgment' do
    let!(:professor) { create(:responsible) }
    let!(:orientation) { create(:orientation) }
    let!(:document) { create(:document_tdo, orientation_id: orientation.id) }

    let(:params) do
      { justification: 'justification', accept: true }
    end

    let(:json_judgment) do
      { responsible: { id: professor.id,
                       accept: params[:accept],
                       justification: params[:justification] } }
    end

    it 'returns true' do
      expect(document.save_judgment(professor, params)).to be(true)
    end
  end

  describe '#update_requester_justification' do
    let!(:academic) { create(:academic) }
    let!(:orientation) { create(:orientation, academic:) }
    let!(:document) { create(:document_tep, orientation_id: orientation.id) }
    let(:params) { { justification: 'new_justification' } }

    it 'returns true when is updated' do
      expect(document.update_requester_justification(params)).to be(true)
    end

    it 'returns when the justification is empty' do
      params = { justification: nil }
      expect(document.update_requester_justification(params)).to be(false)
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
