require 'rails_helper'

# Caracterização (REF-29): o TSO é atualizado no lugar quando só a justificativa muda e é
# recriado quando orientador, professores supervisores ou membros externos mudam.
# Os selects múltiplos enviam um "" escondido antes dos ids, como o formulário real.
RSpec.describe 'Academics TSO request update' do
  let(:academic) { create(:academic) }
  let(:advisor) { create(:professor) }
  let(:supervisor) { create(:professor) }
  let!(:orientation) { create(:orientation, :current, :tcc_one, academic:) }
  let!(:document) do
    request = { requester: { justification: 'just' },
                new_orientation: { advisor: { id: advisor.id, name: advisor.name },
                                   professorSupervisors: [{ id: supervisor.id,
                                                            name: supervisor.name }],
                                   externalMemberSupervisors: [] } }
    create(:document_tso, orientation_id: orientation.id, advisor_id: advisor.id, request:)
  end

  before { login_as(academic, scope: :academic) }

  def submit(advisor_id: advisor.id, professor_ids: [supervisor.id], external_ids: [])
    patch academics_tso_request_path(document),
          params: { document: { justification: 'nova justificativa',
                                advisor_id: advisor_id.to_s,
                                professor_supervisor_ids: [''] + professor_ids.map(&:to_s),
                                external_member_supervisor_ids: [''] + external_ids.map(&:to_s) } }
  end

  def latest_tso
    Document.where(document_type: document.document_type).order(:id).last
  end

  it 'updates in place when only the justification changes' do
    expect { submit }.not_to change(Document, :count)
    expect(document.reload.request['requester']['justification']).to eq('nova justificativa')
    expect(response).to redirect_to(academics_document_path(document))
  end

  it 'recreates the document when the advisor changes' do
    new_advisor = create(:professor)
    submit(advisor_id: new_advisor.id)

    expect(Document.exists?(document.id)).to be(false)
    expect(latest_tso.request['new_orientation']['advisor']['id']).to eq(new_advisor.id)
  end

  it 'recreates the document when the professor supervisors change' do
    other = create(:professor)
    submit(professor_ids: [supervisor.id, other.id])

    expect(Document.exists?(document.id)).to be(false)
    expect(latest_tso.request['new_orientation']['professorSupervisors'].pluck('id'))
      .to contain_exactly(supervisor.id, other.id)
  end

  it 'recreates the document when the external member supervisors change' do
    external_member = create(:external_member)
    submit(external_ids: [external_member.id])

    expect(Document.exists?(document.id)).to be(false)
    expect(latest_tso.request['new_orientation']['externalMemberSupervisors'].pluck('id'))
      .to eq([external_member.id])
  end
end
