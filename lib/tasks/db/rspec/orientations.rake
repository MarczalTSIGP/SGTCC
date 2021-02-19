namespace :rspec do
  namespace :orientation do
    desc 'Run all orientations tests'

    task index: :environment do
      system('bundle exec rspec ' + index_specs.join(' '))
    end

    private

    def index_specs
      [
        'spec/features/responsible/orientations/orientations_index_spec.rb'
      ]
    end
  end
end
