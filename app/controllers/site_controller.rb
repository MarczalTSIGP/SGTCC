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
    @orientations = Orientation.approved
  end

  def approved_tcc_one_orientations
    @page = Page.find_by(url: 'tccs-aprovados-em-tcc-um')
    @orientations = Orientation.approved_tcc_one
  end

  def in_tcc_one_orientations
    @page = Page.find_by(url: 'tccs-em-tcc-um')
    @orientations = Orientation.in_tcc_one
  end

  def sidebar
    render json: Page.publisheds
  end

  def examination_boards
    @proposal_examination_boards  = ExaminationBoard
                                    .proposal
                                    .cs_asc_from_now_desc_ago
    @project_examination_boards   = ExaminationBoard
                                    .project
                                    .cs_asc_from_now_desc_ago
    @monograph_examination_boards = ExaminationBoard
                                    .monograph
                                    .cs_asc_from_now_desc_ago

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
    not_found if @page.blank?
  end

  def set_professor
    @professor = Professor.find(params[:id])
  end
end
