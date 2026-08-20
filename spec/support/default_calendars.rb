# spec/support/default_calendars.rb
RSpec.configure do |config|
  config.before(:suite) do
    # cria calendários correntes
    FactoryBot.create(:calendar, :current, :tcc_one) unless Calendar.exists?(
      year: Calendar.current_year, semester: Calendar.current_semester, tcc: Calendar.tccs[:one]
    )
    FactoryBot.create(:calendar, :current, :tcc_two) unless Calendar.exists?(
      year: Calendar.current_year, semester: Calendar.current_semester, tcc: Calendar.tccs[:two]
    )

    # cria calendários do próximo semestre (necessários para migrate nos specs)
    next_year = Calendar.current_semester == 1 ? Calendar.current_year : Calendar.current_year + 1
    next_semester_value = Calendar.current_semester == 1 ? 2 : 1

    FactoryBot.create(:calendar, :next, :tcc_one) unless Calendar.exists?(
      year: next_year, semester: next_semester_value, tcc: Calendar.tccs[:one]
    )
    FactoryBot.create(:calendar, :next, :tcc_two) unless Calendar.exists?(
      year: next_year, semester: next_semester_value, tcc: Calendar.tccs[:two]
    )
  end
end
