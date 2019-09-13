require 'active_support/concern'

module ProfessorOrientationReport
  extend ActiveSupport::Concern

  included do
    def total_tcc_one_approved_orientations
      tcc_one_approved_orientations.size
    end

    def total_tcc_two_approved_orientations
      tcc_two_approved_orientations.size
    end

    def total_tcc_one_in_progress_orientations
      tcc_one_in_progress_orientations.size
    end

    def total_tcc_two_in_progress_orientations
      tcc_two_in_progress_orientations.size
    end

    def total_orientations_report
      { tcc_one: { approved: total_tcc_one_approved_orientations,
                   in_progress: total_tcc_one_in_progress_orientations },
        tcc_two: { approved: total_tcc_two_approved_orientations,
                   in_progress: total_tcc_two_in_progress_orientations } }
    end
  end
end
