namespace :db do
  desc 'Erase and fill database'

  task populate: :environment do
    require 'faker'
    require 'cpf_cnpj'

    tasks = %w[clean academics professors
               external_members institutions
               base_activities calendars orientations]

    tasks.each do |task|
      Rake::Task["populate:#{task}"].invoke
    end
  end
end
