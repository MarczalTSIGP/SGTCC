require 'rails_helper'

RSpec.describe Orientation do
  describe '#search' do
    let(:orientation) { create(:orientation) }

    context 'when finds orientation by attributes' do
      it 'returns orientation by title' do
        results_search = described_class.search(orientation.title)
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        results_search = described_class.search(orientation.academic.name)
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by academic ra' do
        results_search = described_class.search(orientation.academic.ra)
        expect(orientation.academic.ra).to eq(results_search.first.academic.ra)
      end

      it 'returns orientation by advisor name' do
        results_search = described_class.search(orientation.advisor.name)
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end

      it 'returns orientation by calendar year' do
        year = orientation.calendars.first.year

        results_search = described_class.search(year)
        expect(results_search).to include(orientation)
      end

      it 'returns orientation by institution name' do
        name = orientation.institution.name

        results_search = described_class.search(name)
        expect(results_search).to include(orientation)
      end

      it 'returns orientation by institution trade name' do
        trade_name = orientation.institution.trade_name

        results_search = described_class.search(trade_name)
        expect(results_search).to include(orientation)
      end
    end

    context 'when finds orientation with accents' do
      it 'returns orientation by title' do
        orientation = create(:orientation, title: 'Sistema de Gestão')
        results_search = described_class.search('Sistema de Gestao')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        academic = create(:academic, name: 'João')
        orientation = create(:orientation, academic:)
        results_search = described_class.search(academic.name)
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by advisor name' do
        advisor = create(:professor, name: 'Júlio')
        orientation = create(:orientation, advisor:)
        results_search = described_class.search(advisor.name)
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end
    end

    context 'when finds orientation on search term with accents' do
      it 'returns orientation by title' do
        orientation = create(:orientation, title: 'Sistema de Gestao')
        results_search = described_class.search('Sistema de Gestão')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        academic = create(:academic, name: 'Joao')
        orientation = create(:orientation, academic:)
        results_search = described_class.search('João')
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by advisor name' do
        advisor = create(:professor, name: 'Julio')
        orientation = create(:orientation, advisor:)
        results_search = described_class.search('Júlio')
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end
    end

    context 'when finds orientation ignoring the case sensitive' do
      it 'returns orientation by title' do
        orientation = create(:orientation, title: 'Sistema')
        results_search = described_class.search('sistema')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by title on search term' do
        orientation = create(:orientation, title: 'sistema')
        results_search = described_class.search('SISTEMA')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        academic = create(:academic, name: 'Joao')
        orientation = create(:orientation, academic:)
        results_search = described_class.search('joao')
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by academic name on search term' do
        academic = create(:academic, name: 'joao')
        orientation = create(:orientation, academic:)
        results_search = described_class.search('JOAO')
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by advisor name' do
        advisor = create(:professor, name: 'Julio')
        orientation = create(:orientation, advisor:)
        results_search = described_class.search('julio')
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end

      it 'returns orientation by advisor name on search term' do
        advisor = create(:professor, name: 'julio')
        orientation = create(:orientation, advisor:)
        results_search = described_class.search('JULIO')
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end
    end
  end
end
