require 'rails_helper'

RSpec.describe Institution do
  describe 'formatted cnpj' do
    let(:institution) { create(:institution) }

    it 'returns the cnpj formatted' do
      cnpj = institution.cnpj
      expect(cnpj.formatted).to eq(CNPJ.new(cnpj).formatted)
    end
  end

  describe 'when CNPJ' do
    let(:institution) { build(:institution) }

    it 'validation should reject invalid cnpj' do
      invalid_cnpjs = %w[00000000000000 11111111111111 22222222222222]
      invalid_cnpjs.each do |invalid_cnpj|
        institution.cnpj = invalid_cnpj
        expect(institution.valid?).to be(false), "#{invalid_cnpj.inspect} should be invalid"
        expect(institution.errors[:cnpj]).not_to be_empty
      end
    end

    it 'validation should accept valid cnpj' do
      valid_cnpjs = %w[90794479000178 56990916000190 66270650000165]

      valid_cnpjs.each do |valid_cnpj|
        institution.cnpj = valid_cnpj
        expect(institution.valid?).to be(true), "#{valid_cnpj.inspect} should be valid"
        expect(institution.errors[:cnpj]).to be_empty
      end
    end
  end
end
