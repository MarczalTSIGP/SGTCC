require 'rails_helper'

RSpec.describe Orientations::AcademicActivityQuery do
  # `Calendar.current_semester` consulta a própria tabela: ele cai no `default_semester`
  # com a base vazia, mas passa a derivar do último calendário assim que um é criado.
  # Por isso o período é capturado uma única vez, antes de qualquer criação — calcular
  # de novo depois faria os dois calendários resolverem para o mesmo registro.
  let(:period) { { year: Calendar.current_year, semester: Calendar.current_semester } }

  let(:current_calendar) do
    find_or_create_calendar(year: period[:year], semester: period[:semester],
                            tcc: Calendar.tccs[:one])
  end
  let(:previous_calendar) do
    find_or_create_calendar(year: period[:year], semester: period[:semester] - 1,
                            tcc: Calendar.tccs[:one])
  end

  # Os calendários são passados na criação: reatribuir a coleção depois colide com a
  # validação de unicidade quando a factory já associou o mesmo calendário.
  let(:orientation) { create(:orientation, calendars: [current_calendar]) }

  describe '.call' do
    it 'returns the academic activity matching the identifier' do
      activity = create(:activity, :proposal, calendar: current_calendar)
      academic_activity = create(:academic_activity, activity: activity,
                                                     academic: orientation.academic)

      expect(described_class.call(orientation, :proposal)).to eq(academic_activity)
    end

    it 'returns nil when there is no activity for the identifier' do
      expect(described_class.call(orientation, :monograph)).to be_nil
    end

    it 'ignores activities from calendars outside the orientation' do
      other_calendar = find_or_create_calendar(
        year: period[:year].to_i - 5,
        semester: period[:semester],
        tcc: Calendar.tccs[:one]
      )
      activity = create(:activity, :proposal, calendar: other_calendar)
      create(:academic_activity, activity: activity, academic: orientation.academic)

      expect(described_class.call(orientation, :proposal)).to be_nil
    end

    it 'returns the activity from the most recent calendar' do
      orientation = create(:orientation, calendars: [current_calendar, previous_calendar])
      older = create(:activity, :proposal, calendar: previous_calendar)
      newer = create(:activity, :proposal, calendar: current_calendar)
      create(:academic_activity, activity: older, academic: orientation.academic)
      recent = create(:academic_activity, activity: newer, academic: orientation.academic)

      expect(described_class.call(orientation, :proposal)).to eq(recent)
    end

    describe 'final_version' do
      it 'returns only the final version when it is requested' do
        activity = create(:activity, :proposal, calendar: current_calendar)
        academic_activity = create(:academic_activity, activity: activity,
                                                       academic: orientation.academic)

        expect(described_class.call(orientation, :proposal, final_version: true)).to be_nil

        activity.update(final_version: true)

        expect(described_class.call(orientation, :proposal, final_version: true))
          .to eq(academic_activity)
      end
    end
  end
end
