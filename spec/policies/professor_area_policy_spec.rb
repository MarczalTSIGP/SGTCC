require 'rails_helper'

RSpec.describe ProfessorAreaPolicy do
  it 'grants each area only to the matching role' do
    expect(described_class.new(create(:responsible)))
      .to have_attributes(responsible_area?: true, tcc_one_area?: false)
    expect(described_class.new(create(:professor_tcc_one)))
      .to have_attributes(responsible_area?: false, tcc_one_area?: true)
  end

  it 'denies both areas to a professor without roles' do
    expect(described_class.new(create(:professor)))
      .to have_attributes(responsible_area?: false, tcc_one_area?: false)
  end
end
