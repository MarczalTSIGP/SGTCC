require 'rails_helper'

RSpec.describe OrientationSupervisor, type: :model do
  describe 'associations' do
    p_fk = 'professor_supervisor_id'
    em_fk = 'external_member_supervisor_id'
    it { is_expected.to belong_to(:orientation) }
    it { is_expected.to belong_to(:professor_supervisor).with_foreign_key(p_fk) }
    it { is_expected.to belong_to(:external_member_supervisor).with_foreign_key(em_fk) }
  end
end
