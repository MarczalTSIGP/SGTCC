class Populate::Institutions
  require 'cpf_cnpj'

  attr_reader :external_member_ids

  def initialize
    @external_member_ids = ExternalMember.pluck(:id)
  end

  def populate
    create_institutions
  end

  private

  def create_institutions
    100.times do
      Institution.create!(
        name: Faker::Company.name,
        trade_name: Faker::Company.buzzword,
        cnpj: CNPJ.generate,
        external_member_id: @external_member_ids.sample
      )
    end
  end
end
