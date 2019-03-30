class Responsible::BaseController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorized

  add_breadcrumb I18n.t('breadcrumbs.homepage'), :responsible_root_path

  layout 'layouts/professors/application'

  def authorized
    user = current_professor || current_academic || current_external_member
    return if user.role?(I18n.t('enums.roles.responsible'))

    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to professors_root_path
  end
end
