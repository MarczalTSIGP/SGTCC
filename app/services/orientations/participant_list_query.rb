module Orientations
  class ParticipantListQuery
    SEGMENTS = {
      tcc_one: :current_tcc_one,
      tcc_two: :current_tcc_two,
      history: nil
    }.freeze

    def self.call(relation:, segment:, profile:, **)
      new(relation:, segment:, profile:, **).call
    end

    def initialize(relation:, segment:, profile:, **options)
      @relation = relation
      @segment = segment.to_s.to_sym
      @profile = profile.to_s.to_sym
      @page = options[:page]
      @term = options[:term]
      @status = options[:status]
    end

    def call
      case profile
      when :professor_orientation
        professor_orientation_relation
      when :professor_supervision
        professor_supervision_relation
      when :external_member_supervision
        external_member_supervision_relation
      else
        raise ArgumentError, "Invalid participant list profile: #{profile.inspect}"
      end
    end

    private

    attr_reader :relation, :segment, :page, :term, :status, :profile

    def segment_scope
      SEGMENTS.fetch(segment) do
        raise ArgumentError, "Invalid participant list segment: #{segment.inspect}"
      end
    end

    def segmented(base)
      scope = segment_scope
      return base if scope.blank?

      base.public_send(scope, status)
    end

    def status_filtered(base)
      return base if status.blank?

      base.where(status:)
    end

    def professor_orientation_relation
      base = segmented(status_filtered(relation)).with_relationships.recent

      searched(base).page(page)
    end

    def professor_supervision_relation
      base = status_filtered(relation).with_relationships.recent

      searched(segmented(base)).page(page)
    end

    def external_member_supervision_relation
      base = segment == :history ? status_filtered_when_provided(relation) : relation

      searched(segmented(base)).page(page)
    end

    def searched(base)
      return base if term.blank?

      matching_ids = base.reorder(nil).search(term).select(:id)
      base.where(id: matching_ids)
    end

    def status_filtered_when_provided(base)
      return base if status.nil?

      base.where(status:)
    end
  end
end
