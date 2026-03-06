# spec/support/default_calendars.rb
RSpec.configure do |config|
  config.before(:suite) do
    # cria calendários correntes
    FactoryBot.create(:current_calendar_tcc_one) unless Calendar.exists?(
      year: Calendar.current_year, semester: Calendar.current_semester, tcc: Calendar.tccs[:one]
    )
    FactoryBot.create(:current_calendar_tcc_two) unless Calendar.exists?(
      year: Calendar.current_year, semester: Calendar.current_semester, tcc: Calendar.tccs[:two]
    )

    # cria calendários do próximo semestre (necessários para migrate nos specs)
    FactoryBot.create(:next_calendar_tcc_one) unless Calendar.exists?(
      year: Calendar.current_year + 1, semester: 1, tcc: Calendar.tccs[:one]
    )
    FactoryBot.create(:next_calendar_tcc_two) unless Calendar.exists?(
      year: Calendar.current_year + 1, semester: 1, tcc: Calendar.tccs[:two]
    )
  end
end
