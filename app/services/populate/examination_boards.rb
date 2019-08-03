class Populate::ExaminationBoards
  attr_reader :professors, :external_members, :responsible, :orientation_ids, :tccs

  def initialize
    @professors = Professor.all
    @external_members = ExternalMember.all
    @responsible = Professor.find_by(username: 'marczal')
    @orientation_ids = Orientation.pluck(:id)
    @tccs = ExaminationBoard.tccs
  end

  def populate
    create_examination_boards
  end

  private

  def create_examination_boards
    10.times do |index|
      examination_board = ExaminationBoard.create!(
        orientation_id: @orientation_ids.sample,
        place: "place#{index}",
        date: Faker::Date.forward(1),
        tcc: index > 4 ? @tccs[:one] : @tccs[:two]
      )
      add_guests(examination_board)
    end
  end

  def add_guests(examination_board)
    examination_board.professors << @professors.sample
    examination_board.professors << @responsible
    examination_board.external_members << @external_members.sample
    examination_board.save
  end
end
