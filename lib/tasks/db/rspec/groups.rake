namespace :rspec do
  namespace :examination do
    desc 'Run all tests, even those usually excluded.'

    task list: :environment do
      system("rspec #{index_specs.concat(dashboard_specs).join(' ')}")
    end

    private

    def index_specs
      [
        'spec/features/academics/examination_boards/examination_boards_index_spec.rb',
        'spec/features/external_members/examination_boards/examination_boards_index_spec.rb',
        'spec/features/professors/examination_boards/examination_boards_index_spec.rb',
        'spec/features/responsible/examination_boards/examination_boards_index_spec.rb',
        'spec/features/tcc_one_professors/examination_boards/examination_boards_index_spec.rb'
      ]
    end

    def dashboard_specs
      [
        'spec/features/academics/dashboard/examination_boards_index_spec.rb',
        'spec/features/external_members/dashboard/examination_boards_index_spec.rb',
        'spec/features/professors/dashboard/examination_boards_index_spec.rb',
        'spec/features/tcc_one_professors//dashboard/examination_boards_index_spec.rb'
      ]
    end
  end
end
