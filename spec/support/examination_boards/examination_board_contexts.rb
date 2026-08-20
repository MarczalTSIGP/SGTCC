# rubocop:disable RSpec/ContextWording
RSpec.shared_context 'academic monograph examination board setup' do
  let(:academic) { create(:academic) }
  let(:orientation) { create(:orientation, :tcc_two, academic:) }
  let!(:examination_board) { create(:examination_board, :monograph, orientation:) }

  before do
    create(:document_type_admg)
    examination_board.professors << create(:professor)
    examination_board.external_members << create(:external_member)
    login_as(academic, scope: :academic)
  end
end

RSpec.shared_context 'responsible monograph examination board setup' do
  let(:responsible) { create(:responsible) }
  let(:orientation) { create(:orientation, :tcc_two) }
  let!(:examination_board) { create(:examination_board, :monograph, orientation:) }

  before do
    create(:document_type_admg)
    examination_board.professors << create(:professor)
    examination_board.external_members << create(:external_member)
    login_as(responsible, scope: :professor)
  end
end

RSpec.shared_context 'professor proposal examination board setup' do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:examination_board) { create(:examination_board, :proposal, orientation:) }

  before do
    create(:document_type_adpp)
    login_as(professor, scope: :professor)
  end
end

RSpec.shared_context 'tcc one professor project examination board setup' do
  let(:professor) { create(:professor_tcc_one) }
  let(:orientation) { create(:orientation, :tcc_one) }
  let(:examination_board) { create(:examination_board, :project, orientation:) }

  before do
    create(:document_type_adpj)
    login_as(professor, scope: :professor)
  end
end

RSpec.shared_context 'external member project examination board setup' do
  let(:external_member) { create(:external_member) }
  let(:orientation) { create(:orientation, :tcc_one) }
  let(:examination_board) { create(:examination_board, :project, orientation:) }

  before do
    create(:document_type_adpj)
    examination_board.external_members << external_member
    login_as(external_member, scope: :external_member)
  end
end
# rubocop:enable RSpec/ContextWording
