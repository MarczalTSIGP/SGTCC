module Breadcrumb
  extend ActiveSupport::Concern

  def add_responsible_index_breadcrumb
    @back_url = responsible_orientations_tcc_one_path
    if Calendar.current_calendar?(@calendar)
      @back_url = current_responsible_tcc_index_path
      return orientation_calendar_title, @back_url
    end
    add_breadcrumb I18n.t('breadcrumbs.orientations.index'), @back_url
  end

  def current_responsible_tcc_index_path
    return responsible_orientations_current_tcc_one_path if @calendar.tcc == 'one'
    responsible_orientations_current_tcc_two_path
  end
end
