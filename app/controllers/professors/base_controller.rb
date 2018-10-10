class Professors::BaseController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'layouts/professors/application'
end
