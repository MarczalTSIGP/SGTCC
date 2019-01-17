require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'full title' do
    it 'defaulf' do
      expect(helper.full_title).to eql('SGTCC')
    end
    it 'title' do
      expect(helper.full_title('Home')).to eql('Home | SGTCC')
    end
  end

  describe 'flash' do
    it 'success to bootstrap class alert' do
      expect(helper.bootstrap_class_for('success')).to eql('alert-success')
    end
    it 'error to bootstrap class alert' do
      expect(helper.bootstrap_class_for('error')).to eql('alert-danger')
    end
    it 'alert to bootstrap class alert' do
      expect(helper.bootstrap_class_for('alert')).to eql('alert-warning')
    end
    it 'notice to bootstrap class alert' do
      expect(helper.bootstrap_class_for('notice')).to eql('alert-info')
    end
    it 'any other to same bootstrap class alert' do
      expect(helper.bootstrap_class_for('danger')).to eql('danger')
    end
  end
end
