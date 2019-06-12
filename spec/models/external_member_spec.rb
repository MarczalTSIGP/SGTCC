require 'rails_helper'

RSpec.describe ExternalMember, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:working_area) }

    it { is_expected.to validate_length_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    context 'when email is valid' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
    end

    context 'when email is not valid' do
      it { is_expected.not_to allow_value('foo').for(:email) }
    end

    context 'when personal page is valid' do
      it { is_expected.to allow_value('http://personalpage.com.br').for(:personal_page) }
    end

    context 'when personal page is not valid' do
      it { is_expected.not_to allow_value('personalpage.com').for(:personal_page) }
    end
  end

  describe 'associations' do
    em_fk = 'external_member_supervisor_id'
    it { is_expected.to belong_to(:scholarity) }
    it { is_expected.to have_many(:institutions).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:external_member_supervisors).with_foreign_key(em_fk) }
    it { is_expected.to have_many(:supervisions).through(:external_member_supervisors) }
  end

  describe '#human_genders' do
    it 'returns the genders' do
      genders = ExternalMember.genders
      hash = {}
      genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }

      expect(ExternalMember.human_genders).to eq(hash)
    end
  end

  describe '#search' do
    let(:external_member) { create(:external_member) }

    context 'when finds external member by attributes' do
      it 'returns external member by name' do
        results_search = ExternalMember.search(external_member.name)
        expect(external_member.name).to eq(results_search.first.name)
      end

      it 'returns external member by email' do
        results_search = ExternalMember.search(external_member.email)
        expect(external_member.email).to eq(results_search.first.email)
      end
    end

    context 'when finds external member by name with accents' do
      it 'returns external member' do
        external_member = create(:external_member, name: 'João')
        results_search = ExternalMember.search('Joao')
        expect(external_member.name).to eq(results_search.first.name)
      end
    end

    context 'when finds external member by name on search term with accents' do
      it 'returns external member' do
        external_member = create(:external_member, name: 'Joao')
        results_search = ExternalMember.search('João')
        expect(external_member.name).to eq(results_search.first.name)
      end
    end

    context 'when finds external member by name ignoring the case sensitive' do
      it 'returns external member by attribute' do
        external_member = create(:external_member, name: 'Ana')
        results_search = ExternalMember.search('an')
        expect(external_member.name).to eq(results_search.first.name)
      end

      it 'returns external member by search term' do
        external_member = create(:external_member, name: 'ana')
        results_search = ExternalMember.search('AN')
        expect(external_member.name).to eq(results_search.first.name)
      end
    end

    context 'when returns external members ordered by name' do
      it 'returns ordered' do
        create_list(:external_member, 30)
        external_members_ordered = ExternalMember.order(:name)
        external_member = external_members_ordered.first
        results_search = ExternalMember.search.order(:name)
        expect(external_member.name). to eq(results_search.first.name)
      end
    end
  end

  describe '#current_supervision' do
    let(:external_member) { create(:external_member) }
    let(:calendar_tcc_one) { create(:current_calendar_tcc_one) }
    let(:orientation_tcc_one) { create(:orientation, calendar: calendar_tcc_one) }
    let(:calendar_tcc_two) { create(:current_calendar_tcc_two) }
    let(:orientation_tcc_two) { create(:orientation, calendar: calendar_tcc_two) }

    before do
      orientation_tcc_one.external_member_supervisors << external_member
      orientation_tcc_two.external_member_supervisors << external_member
    end

    it 'returns the current supervision by tcc one' do
      current_supervision = external_member.supervisions.includes(:calendar).select do |supervision|
        supervision.calendar.id == Calendar.current_by_tcc_one.id
      end
      expect(external_member.current_supervision_tcc_one).to eq(current_supervision)
    end

    it 'returns the current supervision by tcc two' do
      current_supervision = external_member.supervisions.includes(:calendar).select do |supervision|
        supervision.calendar.id == Calendar.current_by_tcc_two.id
      end
      expect(external_member.current_supervision_tcc_two).to eq(current_supervision)
    end
  end
end
