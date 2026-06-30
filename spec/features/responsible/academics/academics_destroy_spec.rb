require 'rails_helper'

describe 'Academic::destroy', :js do
  let(:responsible) { create(:responsible) }
  let!(:academic) { create(:academic) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_academics_path
  end

  describe '#destroy' do
    context 'when academic is destroyed' do
      let(:destroy_path) { responsible_academic_path(academic) }
      let(:destroyed_record_name) { academic.name }

      it_behaves_like 'responsible destroy success flow', message_key: 'destroy.m'
    end
  end
end
