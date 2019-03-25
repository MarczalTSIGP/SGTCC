class Responsible::BaseController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  add_breadcrumb I18n.t('breadcrumbs.homepage'), :responsible_root_path

  layout 'layouts/professors/application'

  def pundit_user
    current_professor || current_academic
  end

  def user_not_authorized
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to professors_root_path
  end
end
