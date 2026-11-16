require 'rails_helper'

RSpec.describe ExaminationBoard do
  def jobs_for(type)
    enqueued_jobs.select do |job|
      job[:job] == Notifications::CreateJob && job[:args].first['notification_type'] == type
    end
  end

  let(:board) { create(:examination_board) }

  before do
    board
    state = ExaminationBoardNotificationState.find_by!(examination_board_id: board.id)
    state.targets.each_value { |target| target['delivered'] = true }
    state.save!
    clear_enqueued_jobs
  end

  it 'notifies the academic when scheduling a board' do
    new_board = create(:examination_board)
    expect(jobs_for('examination_board_scheduled').map do |job|
      job[:args].first['recipient']['_aj_globalid']
    end)
      .to include(new_board.orientation.academic.to_global_id.to_s)
  end

  it 'notifies current participants when the place changes' do
    board.update!(place: 'Nova sala')
    expect(jobs_for('examination_board_updated').size).to eq(board.evaluators_number + 1)
  end

  it 'does not notify for unrelated changes' do
    board.update!(document_available_until: 1.month.from_now)
    expect(enqueued_jobs).to be_empty
  end

  it 'notifies added and removed evaluators with distinct messages' do
    removed = board.professors.first
    added = create(:professor)
    board.update!(professor_ids: (board.professor_ids - [removed.id]) + [added.id])
    expect(jobs_for('examination_board_removed').size).to eq(1)
    expect(jobs_for('examination_board_assigned').size).to eq(1)
  end

  it 'notifies participants after successful deletion' do
    board.destroy!
    expect(jobs_for('examination_board_cancelled').size).to eq(5)
  end

  it 'does not notify on rolled back updates' do
    described_class.transaction do
      board.update!(place: 'Rollback')
      raise ActiveRecord::Rollback
    end
    expect(enqueued_jobs).to be_empty
  end

  it 'invalidates earlier jobs when the board is changed again' do
    board.update!(place: 'Sala 1')
    original = jobs_for('examination_board_updated').first[:args].first
    board.update!(place: 'Sala 2')
    expect(Notifications::ExaminationBoards::Validity.call(
             original['notification_type'], original['event_key']
           )).to be_falsey
  end

  it 'invalidates all pending invitations when deleting a board' do
    board.update!(place: 'Sala 1')
    original = jobs_for('examination_board_updated').first[:args].first
    board.destroy!
    expect(Notifications::ExaminationBoards::Validity.call(
             original['notification_type'], original['event_key']
           )).to be_falsey
  end

  it 'preserves an undelivered designation when rescheduling' do
    added = create(:professor)
    board.professors << added
    board.update!(place: 'Updated before delivery')
    jobs = jobs_for('examination_board_assigned')
    expect(jobs.size).to eq(2)
    expect(jobs.last[:args].first['data']['place']).to eq('Updated before delivery')
  end

  it 'preserves pending composition changes in a later location update' do
    added = create(:professor)
    board.professors << added
    board.update!(place: 'Updated before delivery')
    job = jobs_for('examination_board_updated').last[:args].first
    expect(job['data']['added_members']).to include(added.name)
  end

  it 'does not enqueue lifecycle jobs before the primary transaction commits' do
    described_class.transaction do
      board.update!(place: 'Waiting for commit')
      expect(jobs_for('examination_board_updated')).to be_empty
    end
    expect(jobs_for('examination_board_updated')).not_to be_empty
  end
end
