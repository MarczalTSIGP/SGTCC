class Professors::SupervisionsController < Professors::BaseController
  def tcc_one
    supervisions = current_professor.professor_supervisors
    @search_url = professors_orientations_search_tcc_one_path
    @supervisions = []

    @supervisions = supervisions.page(params[:page]).includes(:orientation) if supervisions.present?

    render :index
  end

  def tcc_two
    supervisions = current_professor.professor_supervisors
    @search_url = professors_orientations_search_tcc_one_path
    @supervisions = []

    @supervisions = supervisions.page(params[:page]).includes(:orientation) if supervisions.present?

    render :index
  end
end
