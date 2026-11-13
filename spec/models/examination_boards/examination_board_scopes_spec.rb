require 'rails_helper'

RSpec.describe ExaminationBoard do
  before { travel_to Date.new(2026, 5, 15) }

  describe '.tcc_one' do
    let(:tccs) { [] }

    before do
      tccs << create(:examination_board, :current_tcc_one, :proposal).id
      tccs << create(:examination_board, :current_tcc_one, :project).id

      previous_orientation = create(:orientation, :previous, :tcc_one)
      tccs << create(:examination_board, :tcc_one,
                     date: 6.months.ago,
                     orientation: previous_orientation).id
      tccs << create(:examination_board, :tcc_one,
                     date: 5.months.ago,
                     identifier: :project,
                     orientation: previous_orientation).id
    end

    it 'return all the tccs one' do
      expect(described_class.tcc_one.pluck(:id).sort).to eq(tccs.sort)
    end

    it 'return all the current semester tccs one' do
      tccs.pop(2)
      expect(described_class.tcc_one_current_semester.pluck(:id).sort).to match_array(tccs.sort)
    end
  end

  describe '.tcc_two' do
    let(:tccs) { [] }

    before do
      tccs << create(:examination_board, :current_tcc_two, :monograph).id
      tccs << create(:examination_board, :current_tcc_two, :monograph).id

      previous_orientation = create(:orientation, :previous, :tcc_two)
      tccs << create(:examination_board, :tcc_two,
                     date: 6.months.ago,
                     orientation: previous_orientation).id
      tccs << create(:examination_board, :tcc_two,
                     date: 6.months.ago,
                     identifier: :project,
                     orientation: previous_orientation).id
    end

    it 'return all the tccs two' do
      expect(described_class.tcc_two.pluck(:id).sort).to eq(tccs)
    end

    it 'return all the current semester tccs two' do
      tccs.pop(2)
      expect(described_class.tcc_two_current_semester.pluck(:id).sort).to eq(tccs)
    end
  end

  # Os exemplos acima cobrem o caminho feliz dos dois scopes de período. Estes
  # cobrem o que faltava e que a REF-24 unificou num só lugar: o fallback quando
  # nenhum calendário cobre a data de hoje, a ausência total de calendário, e o
  # encadeamento a partir de uma relation.
  describe '.tcc_one_current_semester' do
    context 'when no calendar covers today' do
      let!(:older_calendar) { create(:calendar, :tcc_one) }
      let!(:newest_calendar) { create(:calendar, :tcc_one) }

      let!(:board_in_newest) do
        create(:examination_board, :tcc_one,
               orientation: create(:orientation, calendars: [newest_calendar]))
      end

      before do
        create(:examination_board, :tcc_one,
               orientation: create(:orientation, calendars: [older_calendar]))
      end

      it 'falls back to the most recent calendar of the tcc' do
        today = Date.current
        covering_today = Calendar.where('start_date <= ? AND end_date >= ?', today, today)

        expect(covering_today).to be_empty
        expect(described_class.tcc_one_current_semester.pluck(:id)).to eq([board_in_newest.id])
      end
    end

    context 'when there is no calendar at all' do
      before do
        create(:examination_board, :current_tcc_one, :proposal)
        create(:examination_board, :current_tcc_two, :monograph)
        OrientationCalendar.delete_all
        Calendar.delete_all
      end

      it 'returns none even with examination boards in the database' do
        expect(described_class.count).to eq(2)
        expect(described_class.tcc_one_current_semester).to be_empty
        expect(described_class.tcc_two_current_semester).to be_empty
      end
    end

    # Com calendário corrente dos dois TCCs na base, cada scope tem que enxergar
    # só o seu. Sem este exemplo, trocar `:two` por `:one` na montagem passa
    # despercebido: o fallback para o calendário mais recente devolveria o
    # calendário certo por acidente.
    context 'when both tccs have a current calendar' do
      let!(:orientation_one) { create(:orientation, :current, :tcc_one) }
      let!(:orientation_two) { create(:orientation, :current, :tcc_two) }

      let!(:board_one) { create(:examination_board, :tcc_one, orientation: orientation_one) }
      let!(:board_two) { create(:examination_board, :tcc_two, orientation: orientation_two) }

      it 'keeps each scope on its own tcc' do
        expect(described_class.tcc_one_current_semester.pluck(:id)).to eq([board_one.id])
        expect(described_class.tcc_two_current_semester.pluck(:id)).to eq([board_two.id])
      end
    end

    # Uma orientação que avançou para TCC II fica ligada aos dois calendários.
    # O filtro por `tcc` da própria banca é o que impede o scope de TCC I de
    # devolver a banca de monografia dessa orientação.
    context 'when the orientation is linked to both calendars' do
      let!(:calendar_one) { create(:calendar, :current, :tcc_one) }
      let!(:calendar_two) { create(:calendar, :current, :tcc_two) }
      let!(:orientation) { create(:orientation, calendars: [calendar_one, calendar_two]) }

      let!(:board_one) { create(:examination_board, :tcc_one, orientation:) }
      let!(:board_two) { create(:examination_board, :tcc_two, orientation:) }

      it 'filters by the tcc of the examination board, not only by the calendar' do
        expect(described_class.tcc_one_current_semester.pluck(:id)).to eq([board_one.id])
        expect(described_class.tcc_two_current_semester.pluck(:id)).to eq([board_two.id])
      end
    end

    context 'when chained with other conditions' do
      let!(:orientation) { create(:orientation, :current, :tcc_one) }

      let!(:confirmed_board) do
        create(:examination_board, :tcc_one, orientation:, place: 'Sala A', confirmed: true)
      end

      let!(:other_board) do
        create(:examination_board, :tcc_one, orientation:, place: 'Sala B')
      end

      it 'preserves conditions applied before the scope' do
        expect(described_class.where(confirmed: true).tcc_one_current_semester.pluck(:id))
          .to eq([confirmed_board.id])
      end

      it 'preserves conditions applied after the scope' do
        expect(described_class.tcc_one_current_semester.where(place: 'Sala B').pluck(:id))
          .to eq([other_board.id])
      end
    end
  end
end
