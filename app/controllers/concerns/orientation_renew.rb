module OrientationRenew
  extend ActiveSupport::Concern

  def renew
    orientation_renewed = orientation.renew(justification)
    if orientation_renewed
      render json: {
        message: I18n.t('json.messages.orientation.renew.save'),
        status: { enum: 'RENEWED', label: orientation_renewed.status }
      }
    else
      msg = I18n.t('json.messages.orientation.calendar.errors.empty_next_semester')
      render json: { message: msg, status: :not_found }
    end
  end

  private

  def justification
    params['orientation']['renewal_justification']
  end

  def orientation
    Orientation.find(params[:id])
  end
end
