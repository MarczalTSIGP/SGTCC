class Populate::ExaminationBoards
  attr_reader :professors, :external_members, :responsible, :orientation_ids, :tccs,
              :tcc_two_identifier, :tcc_one_identifiers

  def initialize
    @professors = Professor.all
    @external_members = ExternalMember.all
    @responsible = Professor.find_by(username: 'marczal')
    @orientation_ids = Orientation.pluck(:id)
    @tccs = ExaminationBoard.tccs
    @tcc_two_identifier = ExaminationBoard.human_tcc_identifiers.values.last
    @tcc_one_identifiers = ExaminationBoard.human_tcc_one_identifiers.values
  end

  def populate
    create_examination_boards
  end

  private

  def create_examination_boards
    10.times do |index|
      examination_board = ExaminationBoard.create!(
        orientation_id: @orientation_ids.sample,
        place: "place#{index}", date: Faker::Date.forward(1),
        document_available_until: Faker::Date.forward(5),
        tcc: select_tcc(index), identifier: select_identifier(index)
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

  def select_tcc(index)
    index > 4 ? @tccs[:one] : @tccs[:two]
  end

  def select_identifier(index)
    index > 4 ? @tcc_one_identifiers.sample : @tcc_two_identifier
  end
end
