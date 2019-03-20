class Responsible::ExternalMembersController < Responsible::BaseController
  before_action :set_external_member, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.external_members.index'),
                 :responsible_external_members_path

  add_breadcrumb I18n.t('breadcrumbs.external_members.show'),
                 :responsible_external_member_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.external_members.new'),
                 :new_responsible_external_member_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.external_members.edit'),
                 :edit_responsible_external_member_path,
                 only: [:edit]

  def index
    @external_members = ExternalMember.page(params[:page]).search(params[:term])
  end

  def show; end

  def new
    @external_member = ExternalMember.new
  end

  def edit; end

  def create
    @external_member = ExternalMember.new(external_member_params)
    @external_member.skip_password_validation = true

    if @external_member.save
      flash[:success] = I18n.t('flash.actions.create.m',
                               resource_name: ExternalMember.model_name.human)
      redirect_to responsible_external_members_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @external_member.update(external_member_params)
      flash[:success] = I18n.t('flash.actions.update.m',
                               resource_name: ExternalMember.model_name.human)
      redirect_to responsible_external_member_path(@external_member)
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    @external_member.destroy

    flash[:success] = I18n.t('flash.actions.destroy.m',
                             resource_name: ExternalMember.model_name.human)

    redirect_to responsible_external_members_path
  end

  private

  def set_external_member
    @external_member = ExternalMember.find(params[:id])
  end

  def external_member_params
    params.require(:external_member).permit(:name, :email, :gender,
                                            :is_active, :personal_page,
                                            :working_area, :scholarity_id)
  end
end
