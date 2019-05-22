namespace :populate do
  desc 'Populate institutions'

  task institutions: :environment do
    puts 'Populating institutions...'

    external_member_ids = ExternalMember.pluck(:id)

    100.times do
      Institution.create(
        name: Faker::Company.name,
        trade_name: Faker::Company.buzzword,
        cnpj: CNPJ.generate,
        external_member_id: external_member_ids.sample
      )
    end
  end
end
