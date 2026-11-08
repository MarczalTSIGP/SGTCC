class TccOneProfessors::BaseController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorized
  include FlashMessage

  add_breadcrumb I18n.t('breadcrumbs.homepage'), :professors_root_path

  layout 'layouts/professors/application'

  def authorized
    return if ProfessorAreaPolicy.new(current_professor).tcc_one_area?

    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to professors_root_path
  end
end
