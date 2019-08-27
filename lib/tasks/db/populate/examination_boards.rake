namespace :populate do
  desc 'Populate examinate boards'

  task examination_boards: :environment do
    puts 'Populating examination boards...'
    Populate::ExaminationBoards.new.populate
  end
end
