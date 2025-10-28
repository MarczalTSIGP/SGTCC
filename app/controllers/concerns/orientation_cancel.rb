module OrientationCancel
  extend ActiveSupport::Concern

  def cancel
    orientation = Orientation.find(params[:id])
    justification = params['orientation']['cancellation_justification']

    return unless orientation.cancel(justification)

    flash[:success] = I18n.t('json.messages.orientation.cancel.success')
    redirect_to responsible_orientation_path(orientation)
  end
end
