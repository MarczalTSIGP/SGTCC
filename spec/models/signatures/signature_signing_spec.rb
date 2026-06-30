require 'rails_helper'

RSpec.describe Signature do
  describe '#sign' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << described_class.all
    end

    it 'returns the new status of the signature' do
      signature = orientation.signatures.first
      signature.sign
      expect(signature.status).to be(true)
    end
  end
end
