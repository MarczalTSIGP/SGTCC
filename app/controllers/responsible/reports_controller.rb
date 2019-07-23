class Responsible::ReportsController < Responsible::BaseController
  def professors_total
    render json: Professor.count
  end

  def professors_available
    render json: Professor.available_advisor.count
  end

  def professors_unavailable
    render json: Professor.unavailable_advisor.count
  end

  def orientations_tcc_one_total
    render json: Orientation.tcc_one('IN_PROGRESS').count
  end

  def orientations_tcc_one_total_approved
    render json: Orientation.tcc_one('APPROVED').count
  end

  def orientations_tcc_one_total_renewed
    render json: Orientation.tcc_one('RENEWED').count / 2
  end

  def orientations_tcc_one_total_canceled
    render json: Orientation.tcc_one('CANCELED').count
  end

  def orientations_tcc_two_total
    render json: Orientation.tcc_two('IN_PROGRESS').count
  end

  def orientations_tcc_two_total_approved
    render json: Orientation.tcc_two('APPROVED').count
  end

  def orientations_tcc_two_total_renewed
    render json: Orientation.tcc_two('RENEWED').count / 2
  end

  def orientations_tcc_two_total_canceled
    render json: Orientation.tcc_two('CANCELED').count
  end
end
