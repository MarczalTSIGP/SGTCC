module OrientationCancel
  extend ActiveSupport::Concern

  def cancel
    orientation = Orientation.find(params[:id])
    justification = params['orientation']['cancellation_justification']

    if justification.blank?
      flash[:error] = I18n.t('json.messages.empty_fields')
      redirect_to responsible_orientation_path(orientation)
      return
    end

    return unless orientation.cancel(justification)

    flash[:success] = I18n.t('json.messages.orientation.cancel.success')
    redirect_to responsible_orientation_path(orientation)
  end
end
