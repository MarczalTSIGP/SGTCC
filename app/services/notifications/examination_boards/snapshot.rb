module Notifications
  module ExaminationBoards
    class Snapshot
      def self.call(board)
        {
          'date' => board.date.iso8601, 'place' => board.place,
          'academic_name' => board.orientation.academic.name,
          'orientation_title' => board.orientation.title,
          'recipients' => recipients(board).to_h do |user|
            ["#{user.class.name}:#{user.id}", user.name]
          end
        }
      end

      def self.recipients(board)
        (board.professors.to_a + board.external_members.to_a +
          [board.orientation.advisor, board.orientation.academic]).uniq
      end
    end
  end
end
