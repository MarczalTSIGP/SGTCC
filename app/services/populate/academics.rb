class Populate::Academics
  attr_reader :genders

  def initialize
    @genders = Academic.genders.values
  end

  def populate
    create_academics
  end

  private

  def create_academics
    100.times do
      Academic.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        ra: Faker::Number.number(digits: 7),
        gender: @genders.sample,
        password: '123456',
        password_confirmation: '123456'
      )
    end
  end
end
