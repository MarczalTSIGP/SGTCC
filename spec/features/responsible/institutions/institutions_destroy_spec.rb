require 'rails_helper'

describe 'Institution::destroy', :js do
  let(:responsible) { create(:responsible) }
  let!(:institution) { create(:institution) }
  let(:resource_name) { Institution.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_institutions_path
  end

  describe '#destroy' do
    context 'when institution is destroyed' do
      let(:destroy_path) { responsible_institution_path(institution) }
      let(:destroyed_record_name) { institution.name }

      it_behaves_like 'responsible destroy success flow', message_key: 'destroy.f'
    end
  end
end
