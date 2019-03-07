require 'rails_helper'

RSpec.describe Role, type: :model do
  it { is_expected.to have_many(:assignments).dependent(:destroy) }
end
