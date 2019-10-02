FactoryBot.define do
  factory :academic_activity do
    academic
    activity
    pdf { 'MyString' }
    complementary_files { 'MyString' }
    title { 'MyString' }
    summary { 'MyText' }
  end
end
