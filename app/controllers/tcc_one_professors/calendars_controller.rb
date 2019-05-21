class TccOneProfessors::CalendarsController < TccOneProfessors::BaseController
  def tcc_one
    @calendars = Calendar.search_by_tcc_one(params[:page], params[:term])
                         .includes(:orientations)

    @search_url = tcc_one_professors_calendars_search_tcc_one_path
    render :index
  end
end
