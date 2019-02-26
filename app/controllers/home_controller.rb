class HomeController < ApplicationController
  def index
    redirect_to new_responsible_session_path
  end
end
