require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title' do
    context 'when not receives any param' do
      it 'show title' do
        expect(helper.full_title).to eql('SGTCC')
      end
    end

    context 'when receives param' do
      it 'show {param} | title' do
        expect(helper.full_title('Home')).to eql('Home | SGTCC')
      end
    end
  end

  describe '#complete_date' do
    context 'when not receives param' do
      it 'show complete date' do
        date = Time.zone.now
        converted_date = I18n.localize(date, format: :long)
        expect(helper.complete_date(date)).to eql(converted_date)
      end
    end
  end

  describe '#external_link_to' do
    context 'when receives the link' do
      it 'show the link tag' do
        link = 'https://www.test.com.br'
        link_tag = "<a href=\"#{link}\" target=\"_blank\">#{link}</a>"
        expect(helper.external_link_to(link)).to eql(link_tag)
      end
    end
  end
end
