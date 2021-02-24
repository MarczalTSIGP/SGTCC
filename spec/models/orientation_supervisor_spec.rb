require 'rails_helper'

RSpec.describe OrientationSupervisor, type: :model do
  subject(:orientation_supervisor) { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }

    it 'is expected to belongs to' do
      expect(orientation_supervisor).to belong_to(:professor_supervisor)
    end

    it 'is expected to belong to' do
      expect(orientation_supervisor).to belong_to(:external_member_supervisor)
    end

    it { is_expected.to have_many(:examination_boards).through(:orientation) }
  end
end
