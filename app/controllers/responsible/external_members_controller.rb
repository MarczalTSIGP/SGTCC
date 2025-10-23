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
    @external_members = ExternalMember.page(params[:page]).search(params[:term]).order(:name)
  end

  def show; end

  def new
    @external_member = ExternalMember.new
  end

  def edit; end

  def create
    @external_member = ExternalMember.new(external_member_params)

    if @external_member.save
      send_registration_email(@external_member, external_member_params[:password])
      success_create_message
      redirect_to responsible_external_members_path
    else
      error_message
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @external_member.define_singleton_method(:password_required?) { false }

    if @external_member.update(external_member_params)
      success_update_message
      redirect_to responsible_external_member_path(@external_member)
    else
      error_message
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @external_member.destroy
      success_destroy_message
    else
      alert_destroy_bond_message
    end

    redirect_to responsible_external_members_path
  end

  private

  def send_registration_email(external_member, password)
    ExternalMemberMailer.with(external_member:,
                              password:)
                        .registration_email.deliver_later
  end

  def set_external_member
    @external_member = ExternalMember.find(params[:id])
  end

  def external_member_params
    params.require(:external_member).permit(:name, :email, :gender,
                                            :password, :password_confirmation,
                                            :is_active, :personal_page,
                                            :working_area, :scholarity_id)
  end
end
