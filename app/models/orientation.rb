class Orientation < ApplicationRecord
  include Searchable
  include OrientationStatus
  include OrientationFilter
  include Signable
  include OrientationJoin

  searchable :status, title: { unaccent: true }, relationships: {
    calendar: { fields: [:year] },
    academic: { fields: [name: { unaccent: true }, ra: { unaccent: false }] },
    institution: { fields: [name: { unaccent: true }, trade_name: { unaccent: true }] },
    advisor: { table_name: 'professors', fields: [name: { unaccent: true }] }
  }

  belongs_to :calendar
  belongs_to :academic
  belongs_to :advisor, class_name: 'Professor', inverse_of: :orientations
  belongs_to :institution, optional: true

  has_many :orientation_supervisors, dependent: :delete_all

  has_many :signatures, dependent: :destroy

  has_many :professor_supervisors,
           class_name: 'Professor',
           foreign_key: :professor_supervisor_id,
           through: :orientation_supervisors,
           dependent: :destroy

  has_many :external_member_supervisors,
           class_name: 'ExternalMember',
           foreign_key: :external_member_supervisor_id,
           through: :orientation_supervisors,
           dependent: :destroy

  validates :title, presence: true
  validate :validates_supervisor_ids

  scope :tcc_one, lambda { |status|
    join_with_status(joins(:calendar).where(calendars: { tcc: Calendar.tccs[:one] }), status)
  }

  scope :tcc_two, lambda { |status|
    join_with_status(joins(:calendar).where(calendars: { tcc: Calendar.tccs[:two] }), status)
  }

  scope :current_tcc_one, lambda { |status|
    join_with_status(join_current_calendar_tcc_one, status)
  }

  scope :current_tcc_two, lambda { |status|
    join_with_status(join_current_calendar_tcc_two, status)
  }

  scope :with_relationships, lambda {
    includes(:advisor, :academic, :calendar,
             :professor_supervisors, :orientation_supervisors, :external_member_supervisors)
  }

  scope :recent, -> { order('calendars.year DESC, calendars.semester ASC, title, academics.name') }

  after_save do
    document_type = DocumentType.find_by(name: I18n.t('signatures.documents.TCO'))
    Documents::SaveSignatures.new(self, document_type&.id).save
  end

  after_update do
    signatures.destroy_all
  end

  def short_title
    title.length > 35 ? "#{title[0..35]}..." : title
  end

  def validates_supervisor_ids
    return true unless professor_supervisor_ids.include?(advisor_id)
    message = I18n.t('activerecord.errors.models.orientation.attributes.supervisors.advisor',
                     advisor: advisor.name)
    errors.add(:professor_supervisors, message)
    false
  end

  def supervisors
    professor_supervisors + external_member_supervisors
  end

  def renew(justification)
    next_calendar = Calendar.next_semester(calendar)
    return false if next_calendar.blank?
    self.renewal_justification = justification
    self.status = 'RENEWED'
    save
    new_orientation = dup
    new_orientation.calendar = next_calendar
    new_orientation.save
    new_orientation
  end

  def cancel(justification)
    self.cancellation_justification = justification
    self.status = 'CANCELED'
    save
  end

  def can_be_renewed?(professor)
    professor&.role?(:responsible) && calendar_tcc_two? && in_progress?
  end

  def can_be_canceled?(professor)
    professor&.role?(:responsible) && !canceled?
  end

  def can_be_edited?
    signatures.where(status: true).empty?
  end

  def calendar_tcc_one?
    calendar.tcc == 'one'
  end

  def calendar_tcc_two?
    calendar.tcc == 'two'
  end

  def signed_signatures
    signatures.where(status: true)
  end
end
