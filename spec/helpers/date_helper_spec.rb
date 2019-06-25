require 'rails_helper'

RSpec.describe DateHelper, type: :helper do
  describe '#complete_date' do
    it 'shows complete date' do
      date = Time.zone.now
      converted_date = I18n.localize(date, format: :long)
      expect(helper.complete_date(date)).to eql(converted_date)
    end
  end

  describe '#short_date' do
    it 'shows short date' do
      date = Time.zone.now
      converted_date = I18n.localize(date, format: :short)
      expect(helper.short_date(date)).to eql(converted_date)
    end
  end

  describe '#document_date' do
    it 'shows document date' do
      date = Time.zone.now
      converted_date = I18n.localize(date, format: :document)
      expect(helper.document_date(date)).to eql(converted_date)
    end
  end
end
