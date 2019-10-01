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

  def in_progress_orientations
    @page = Page.find_by(url: 'tccs-em-andamento')
  end

  def approved_orientations_by_year(status: 'APPROVED', year: params[:year])
    render_orientations(Orientation.tcc_two(status, year, 'one'),
                        Orientation.tcc_two(status, year, 'two'))
  end

  def in_progress_orientations_by_year(status: 'IN_PROGRESS', year: params[:year])
    data = { tcc_one: { first_semester: Orientation.tcc_one(status, year, 'one'),
                        second_semester: Orientation.tcc_one(status, year, 'two') },
             tcc_two: { first_semester: Orientation.tcc_two(status, year, 'one'),
                        second_semester: Orientation.tcc_two(status, year, 'two') } }
    render json: Orientation.to_json_table(data)
  end

  def sidebar
    render json: Page.publisheds
  end

  def examination_boards
    @examination_boards_tcc_one = examination_board_data(ExaminationBoard.tcc_one)
    @examination_boards_tcc_two = examination_board_data(ExaminationBoard.tcc_two)

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
    data.includes(external_members: [:scholarity],
                  professors: [:scholarity],
                  orientation: [:academic, :orientation_supervisors, :professor_supervisors,
                                :external_member_supervisors, advisor: [:scholarity]])
        .recent
  end

  def set_professor
    @professor = Professor.find(params[:id])
  end

  def render_orientations(first_semester_data, second_semester_data)
    data = { first_semester: first_semester_data.with_relationships.recent,
             second_semester: second_semester_data.with_relationships.recent }
    render json: Orientation.to_json_table(data)
  end
end
