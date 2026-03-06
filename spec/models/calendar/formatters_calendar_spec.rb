require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe '#year_with_semester' do
    it 'returns year/semester formatted' do
      calendar = create(:current_calendar)
      semester = I18n.t("enums.semester.#{calendar.semester}")
      expect(calendar.year_with_semester).to eq("#{calendar.year}/#{semester}")
    end
  end

  describe '#year_with_semester_and_tcc' do
    it 'returns year/semester - TCC: tcc' do
      calendar = create(:current_calendar)
      semester = I18n.t("enums.semester.#{calendar.semester}")
      tcc = I18n.t("enums.tcc.#{calendar.tcc}")

      expected_text = calendar.year_with_semester_and_tcc
      result_text = "#{calendar.year}/#{semester} - TCC: #{tcc}"
      expect(expected_text).to eq(result_text)
    end
  end
end
