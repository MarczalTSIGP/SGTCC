require 'active_support/concern'

module ExaminationBoardEvaluatorSign
  extend ActiveSupport::Concern

  included do
    def evaluator_sign?(user, user_type)
      return false if defense_minutes.blank?
      defense_minutes.signatures.find_by(user_type: user_type, user_id: user.id).status
    end

    def advisor_sign?
      evaluator_sign?(orientation.advisor, :advisor)
    end

    def professor_evaluator_sign?(professor)
      advisor?(professor) ? advisor_sign? : evaluator_sign?(professor, :professor_evaluator)
    end

    def external_member_evaluator_sign?(external_member)
      external_member_evaluator?(external_member) &&
        evaluator_sign?(external_member, :external_member_evaluator)
    end
  end
end
