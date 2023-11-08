module FlashMessage
  extend ActiveSupport::Concern

  def success_create_message(gender: 'm')
    flash[:success] = I18n.t("flash.actions.create.#{gender}", resource_name: model_human)
  end

  def feminine_success_create_message
    success_create_message(gender: 'f')
  end

  def success_update_message(gender: 'm')
    flash[:success] = I18n.t("flash.actions.update.#{gender}", resource_name: model_human)
  end

  def feminine_success_update_message
    success_update_message(gender: 'f')
  end

  def success_destroy_message(gender: 'm')
    flash[:success] = I18n.t("flash.actions.destroy.#{gender}", resource_name: model_human)
  end

  def feminine_success_destroy_message
    success_destroy_message(gender: 'f')
  end

  def alert_destroy_bond_message
    flash[:alert] = I18n.t('flash.actions.destroy.bond', resource_name: model_human)
  end

  def error_message
    flash.now[:error] = I18n.t('flash.actions.errors')
  end

  private

  def model_human
    model = controller_name.classify.constantize
    model.model_name.human
  end
end
