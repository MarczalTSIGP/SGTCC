require 'rails_helper'

RSpec.describe Orientation do
  # Conta as consultas reais disparadas, ignorando SCHEMA e controle de transação.
  def count_queries
    count = 0
    subscriber = ActiveSupport::Notifications.subscribe('sql.active_record') do |*, payload|
      next if payload[:name].in?(%w[SCHEMA TRANSACTION])
      next if payload[:sql].start_with?('BEGIN', 'COMMIT', 'ROLLBACK', 'SAVEPOINT', 'RELEASE')

      count += 1
    end

    yield

    count
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber)
  end

  # Caracterização do conjunto devolvido hoje, para servir de rede antes da mudança.
  describe 'record set' do
    # Período capturado uma vez: Calendar.current_semester consulta a própria tabela e
    # muda de resposta depois que o primeiro calendário é criado.
    let(:period) { { year: Calendar.current_year, semester: Calendar.current_semester } }
    let(:calendar) do
      find_or_create_calendar(year: period[:year], semester: period[:semester],
                              tcc: Calendar.tccs[:two])
    end

    describe '.approved' do
      it 'includes an approved orientation that has a final monograph' do
        orientation = create(:orientation, :tcc_two, :approved, :with_final_monograph)

        expect(described_class.approved).to include(orientation)
      end

      it 'excludes an approved orientation without a final monograph' do
        orientation = create(:orientation, :tcc_two, :approved)

        expect(described_class.approved).not_to include(orientation)
      end

      it 'excludes an orientation whose monograph is not the final version' do
        orientation = create(:orientation, :tcc_two, :approved, calendars: [calendar])
        activity = create(:activity, :monograph, calendar: calendar, final_version: false)
        create(:academic_activity, :monograph, activity: activity, academic: orientation.academic)

        expect(described_class.approved).not_to include(orientation)
      end

      it 'excludes an orientation whose final monograph belongs to another calendar' do
        other_calendar = find_or_create_calendar(year: period[:year].to_i - 3,
                                                 semester: period[:semester],
                                                 tcc: Calendar.tccs[:two])
        orientation = create(:orientation, :tcc_two, :approved, calendars: [calendar])
        activity = create(:activity, :monograph, calendar: other_calendar, final_version: true)
        create(:academic_activity, :monograph, activity: activity, academic: orientation.academic)

        expect(described_class.approved).not_to include(orientation)
      end

      it 'includes an orientation with a final monograph and no examination board' do
        orientation = create(:orientation, :tcc_two, :approved, calendars: [calendar])
        activity = create(:activity, :monograph, calendar: calendar, final_version: true)
        create(:academic_activity, :monograph, activity: activity, academic: orientation.academic)

        expect(described_class.approved).to include(orientation)
      end

      it 'orders by the examination board date, most recent first' do
        older = create(:orientation, :tcc_two, :approved, :with_final_monograph)
        newer = create(:orientation, :tcc_two, :approved, :with_final_monograph)
        older.examination_boards.first.update!(date: 10.days.ago)
        newer.examination_boards.first.update!(date: 1.day.ago)

        expect(described_class.approved.map(&:id).first(2)).to eq([newer.id, older.id])
      end

      it 'excludes an orientation with another status' do
        orientation = create(:orientation, :tcc_two, :with_final_monograph)

        expect(described_class.approved).not_to include(orientation)
      end
    end

    describe '.approved_tcc_one' do
      it 'includes an approved tcc one orientation that has a final project' do
        orientation = create(:orientation, :tcc_one, :approved_tcc_one, :with_final_project)

        expect(described_class.approved_tcc_one).to include(orientation)
      end

      it 'excludes an approved tcc one orientation without a final project' do
        orientation = create(:orientation, :tcc_one, :approved_tcc_one)

        expect(described_class.approved_tcc_one).not_to include(orientation)
      end
    end
  end

  describe '.approved' do
    it 'does not run more queries as more orientations are added' do
      create_list(:orientation, 2, :tcc_two, :approved, :with_final_monograph)
      described_class.approved.to_a
      queries_with_two = count_queries { described_class.approved.to_a }

      create_list(:orientation, 2, :tcc_two, :approved, :with_final_monograph)
      queries_with_four = count_queries { described_class.approved.to_a }

      expect(queries_with_four).to eq(queries_with_two)
    end
  end

  describe '.approved_tcc_one' do
    it 'does not run more queries as more orientations are added' do
      create_list(:orientation, 2, :tcc_one, :approved_tcc_one, :with_final_project)
      described_class.approved_tcc_one.to_a
      queries_with_two = count_queries { described_class.approved_tcc_one.to_a }

      create_list(:orientation, 2, :tcc_one, :approved_tcc_one, :with_final_project)
      queries_with_four = count_queries { described_class.approved_tcc_one.to_a }

      expect(queries_with_four).to eq(queries_with_two)
    end
  end
end
