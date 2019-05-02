require 'rails_helper'

RSpec.describe OrientationSupervisor, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }
    it { is_expected.to belong_to(:supervisor).class_name(Professor.to_s) }
  end
end
