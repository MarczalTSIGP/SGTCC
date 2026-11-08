require 'rails_helper'

RSpec.describe RequestPolicy do
  describe 'academic requester' do
    let(:academic) { create(:academic) }
    let(:orientation) { create(:orientation, academic:) }
    let(:document) { create(:document_tep, orientation_id: orientation.id) }
    let(:policy) { described_class.new(academic, document) }

    it 'allows changing before signing' do
      expect(policy.change?).to be(true)
    end

    it 'denies changing after signing' do
      document.signature_by_user(academic, :academic).sign
      expect(policy.change?).to be(false)
    end
  end

  describe 'professor requester' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation, advisor: professor) }
    let(:document) { create(:document_tdo, orientation_id: orientation.id) }
    let(:policy) { described_class.new(professor, document) }

    it 'allows changing before signing' do
      expect(policy.change?).to be(true)
    end

    it 'denies changing after signing' do
      document.signature_by_user(professor.id, professor.user_types).sign
      expect(policy.change?).to be(false)
    end
  end

  it 'rejects an unsupported requester' do
    expect { described_class.new(build(:external_member), build(:document)).change? }
      .to raise_error(ArgumentError, /Unsupported requester/)
  end
end
