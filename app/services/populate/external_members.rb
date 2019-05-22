class Populate::ExternalMembers
  attr_reader :genders, :scholarity_ids

  def initialize
    @genders = ExternalMember.genders.values
    @scholarity_ids = Scholarity.pluck(:id)
  end

  def populate
    create_external_members
  end

  private

  def create_external_members
    100.times do |index|
      create_external_member(index)
    end
  end

  def create_external_member(index)
    ExternalMember.create(
      name: Faker::Name.name, email: Faker::Internet.email,
      password: '123456', password_confirmation: '123456',
      is_active: Faker::Boolean.boolean, working_area: Faker::Markdown.headers,
      gender: @genders.sample, personal_page: "http://page.com.#{index}",
      scholarity_id: @scholarity_ids.sample
    )
  end
end
