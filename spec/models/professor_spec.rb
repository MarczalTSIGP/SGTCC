require 'rails_helper'

RSpec.describe Professor, type: :model do
  let(:professor) { create(:professor) }

  it 'is valid with valid attributes' do
    expect(professor).to be_valid
  end

  it 'is not valid with email too long' do
    professor.email = 'a' * 256 + '@example.com'
    expect(professor).not_to be_valid
  end

  it 'is valid with valid email addresses' do
    valid_addresses = %w[professor@xample.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      professor.email = valid_address
      expect(professor).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end

  it 'is not valid with invalid email addresses' do
    invalid_addresses = %w[professor@example,com user_at_foo.org professor.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      professor.email = invalid_address
      expect(professor).not_to be_valid, "#{invalid_address.inspect} should be invalid"
    end
  end

  it 'is not valid with email unique' do
    duplicate_professor = professor.dup
    duplicate_professor.email = professor.email.upcase
    professor.save
    expect(duplicate_professor).not_to be_valid
  end

  it 'is not valid with password minimum length' do
    professor.password = professor.password_confirmation = 'a' * 5
    expect(professor).not_to be_valid
  end
end
