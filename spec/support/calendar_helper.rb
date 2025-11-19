module CalendarHelper
  def find_or_create_calendar(year:, semester:, tcc:)
    # Ajusta o semestre > 2
    semester = case semester.to_i
              when 1 then "one"
              when 2 then "two"
              when 3
                # se for 3, é próximo ano, primeiro semestre
                year = year.to_i + 1
                "one"
              else
                raise "Invalid semester #{semester}"
              end

    Calendar.find_by(year: year.to_s, semester: semester, tcc: tcc) ||
      create(:calendar,
             year: year.to_s,
             semester: semester,
             tcc: tcc,
             start_date: semester == "one" ? Date.new(year.to_i, 1, 1) : Date.new(year.to_i, 7, 1),
             end_date:   semester == "one" ? Date.new(year.to_i, 6, 30) : Date.new(year.to_i, 12, 31))
  end
end
FactoryBot::SyntaxRunner.include CalendarHelper