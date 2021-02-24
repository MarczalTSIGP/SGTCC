class TccOneProfessors::CalendarsController < TccOneProfessors::BaseController
  add_breadcrumb I18n.t('breadcrumbs.calendars.index'),
                 :tcc_one_professors_calendars_tcc_one_path

  def tcc_one
    @calendars = Calendar.search_by_tcc_one(params[:page], params[:term])

    @search_url = tcc_one_professors_calendars_search_tcc_one_path
    render :index
  end
end
