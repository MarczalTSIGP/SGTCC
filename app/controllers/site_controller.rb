class SiteController < ApplicationController
  layout 'layouts/site/application'

  before_action :set_page, only: :page
  before_action :set_pages, only: :index
  before_action :set_site, only: :sidebar
  before_action :set_professor, only: :professor

  def index
    if @pages.present?
      redirect_to action: :page, page: @pages.first.url
    else
      render 'site/page'
    end
  end

  def page; end

  def calendar
    @calendar_tcc_one = Calendar.current_by_tcc_one
    @calendar_tcc_two = Calendar.current_by_tcc_two
    @activities_tcc_one = @calendar_tcc_one.activities.includes(:base_activity_type).recent
    @activities_tcc_two = @calendar_tcc_two.activities.includes(:base_activity_type).recent
    @page = Page.find_by(url: 'calendario')
  end

  def professors
    @effective_professors = Professor.effective.includes(:scholarity).order(:name)
    @temporary_professors = Professor.temporary.includes(:scholarity).order(:name)
    @page = Page.find_by(url: 'professores')
  end

  def professor; end

  def approved_orientations
    @page = Page.find_by(url: 'tccs-aprovados')
  end

  def approved_tcc_one_orientations
    @page = Page.find_by(url: 'tccs-aprovados-em-tcc-um')
  end

  def in_tcc_one_orientations
    @page = Page.find_by(url: 'tccs-em-tcc-um')
  end

  #   render_orientations(Orientation.tcc_two(status, year, 'one'),
  #                       Orientation.tcc_two(status, year, 'two'))
  # end

  # def in_progress_orientations_by_year(status: 'IN_PROGRESS', year: params[:year])
  #   tcc_one = { first_semester: orientations_data(Orientation.tcc_one(status, year, 'one')),
  #               second_semester: orientations_data(Orientation.tcc_one(status, year, 'two')) }

  #   status = 'APPROVED_TCC_ONE'
  #   tcc_two = { first_semester: orientations_data(Orientation.tcc_two(status, year, 'one')),
  #               second_semester: orientations_data(Orientation.tcc_two(status, year, 'two')) }

  #   data = { tcc_one: tcc_one, tcc_two: tcc_two }
  #   render json: Orientation.to_json_table(data)
  # end

  def sidebar
    render json: Page.publisheds
  end

  def examination_boards
    @proposal_examination_boards = ExaminationBoard.proposal.order_by_asc_from_now_desc_ago
    @project_examination_boards = examination_board_data(ExaminationBoard.project)
    @monograph_examination_boards = examination_board_data(ExaminationBoard.monograph)

    @page = Page.find_by(url: 'bancas-de-tcc')
  end

  private

  def set_pages
    @pages = Page.publisheds
  end

  def set_site
    @site = Site.first
  end

  def set_page
    @page = Page.find_by(url: params[:page])
    return not_found if @page.blank?
  end

  def examination_board_data(data)
    data.current_semester.site_with_relationships
  end

  # def orientations_data(data)
  #   data.includes(:academic, :calendars, :documents,
  #                 :orientation_supervisors, :external_member_supervisors,
  #                 :professor_supervisors, :advisor)
  # end

  def set_professor
    @professor = Professor.find(params[:id])
  end

  # def render_orientations(first_semester_data, second_semester_data)
  #   data = { first_semester: first_semester_data.with_relationships.recent,
  #            second_semester: second_semester_data.with_relationships.recent }
  #   render json: Orientation.to_json_table(data)
  # end
end
