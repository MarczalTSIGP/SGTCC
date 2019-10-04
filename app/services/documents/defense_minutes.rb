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
    add_professor_supervisors
    add_external_member_supervisors
    add_evaluators
    create_signatures
  end

  def add_evaluators
    @document.examination_board[:evaluators].each do |evaluator|
      @signature_users.push([evaluator[:id], 'EV'])
    end
  end
end
