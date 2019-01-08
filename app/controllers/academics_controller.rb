class AcademicsController < Professors::BaseController
  before_action :set_academic, only: [:show, :edit, :update, :destroy]

  def index
    @academics = Academic.all
  end

  def show
  end

  def new
    @academic = Academic.new
  end

  def edit
  end

  def create
    @academic = Academic.new(academic_params)

    if @academic.save
      flash[:success] = I18n.t('flash.actions.create.m',
                               resource_name: Academic.model_name.human)
      redirect_to @academic
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @academic.update(academic_params)
      flash[:success] = I18n.t('flash.actions.update.m',
                               resource_name: Academic.model_name.human)
      redirect_to @academic
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    @academic.destroy
    flash[:success] = I18n.t('flash.actions.destroy.m',
                             resource_name: Academic.model_name.human)
    redirect_to academics_url
  end

  private

  def set_academic
    @academic = Academic.find(params[:id])
  end

  def academic_params
    params.require(:academic).permit(:name, :email, :ra, :gender)
  end
end
