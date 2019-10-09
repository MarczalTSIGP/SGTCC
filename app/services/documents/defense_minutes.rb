module Documents::DefenseMinutes
  def save_adpp
    save_add
  end

  def save_adpj
    save_add
  end

  def save_admg
    save_add
  end

  def save_add
    add_advisor
    add_academic
    add_evaluators('professors', 'PV')
    add_evaluators('external_members', 'EMV')
    create_signatures
  end

  def add_evaluators(evaluators, user_type)
    examination_board = @document.examination_board
    return if examination_board.blank?
    examination_board[:evaluators][evaluators.to_sym].each do |evaluator|
      @signature_users.push([evaluator[:id], user_type])
    end
  end
end
