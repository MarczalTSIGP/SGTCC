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
