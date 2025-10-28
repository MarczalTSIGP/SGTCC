module OrientationCancel
  extend ActiveSupport::Concern

  def cancel
    orientation = Orientation.find(params[:id])
    justification = cancellation_justification

    return handle_empty_justification(orientation) if justification.blank?
    return unless orientation.cancel(justification)

    handle_successful_cancellation(orientation)
  end

  private

  def cancellation_justification
    params['orientation']['cancellation_justification']
  end

  def handle_empty_justification(orientation)
    flash[:error] = I18n.t('json.messages.empty_fields')
    redirect_to responsible_orientation_path(orientation)
  end

  def handle_successful_cancellation(orientation)
    flash[:success] = I18n.t('json.messages.orientation.cancel.success')
    redirect_to responsible_orientation_path(orientation)
  end
end
