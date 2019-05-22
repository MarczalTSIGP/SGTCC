namespace :populate do
  desc 'Populate institutions'

  task institutions: :environment do
    puts 'Populating institutions...'

    100.times do
      Institution.create(
        name: Faker::Company.name,
        trade_name: Faker::Company.buzzword,
        cnpj: CNPJ.generate,
        external_member_id: ExternalMember.pluck(:id).sample
      )
    end
  end
end
