require 'rails_helper'

describe 'Professors::report', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Professor.model_name.human }

  before do
    create_list(:professor, 10)
    login_as(responsible, scope: :professor)
  end

  describe '#reports' do
    let(:professors_url) { responsible_professors_path }
    let(:professors_available_url) { responsible_professors_available_path }
    let(:professors_unavailable_url) { responsible_professors_unavailable_path }

    before do
      visit responsible_root_path
    end

    it 'returns the professors total component' do
      total = Professor.count
      expect(page).to have_contents([total,
                                     professors_label,
                                     professors_total_label])
      expect(page).to have_selector(link(professors_url))
    end

    it 'returns the total professors available component' do
      total_available = Professor.available_advisor.count
      expect(page).to have_contents([total_available,
                                     professors_label,
                                     professors_available_label])
      expect(page).to have_selector(link(professors_available_url))
    end

    it 'returns the total professors unavailable component' do
      total_unavailable = Professor.unavailable_advisor.count
      expect(page).to have_contents([total_unavailable,
                                     professors_label,
                                     professors_unavailable_label])
      expect(page).to have_selector(link(professors_unavailable_url))
    end
  end
end
