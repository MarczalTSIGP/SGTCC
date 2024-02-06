class Document < ApplicationRecord
  include TermJsonData
  include SignatureMark
  include DocumentSigned
  include DocumentByType
  include DocumentReview

  attr_accessor :orientation_id, :advisor_id, :justification,
                :professor_supervisor_ids, :external_member_supervisor_ids,
                :examination_board

  belongs_to :document_type

  has_many :signatures, dependent: :destroy

  validates :justification, :orientation_id, presence: true, if: -> { document_type.tdo? }
  validates :justification, presence: true, if: -> { document_type.tep? }
  validates :justification, :advisor_id, presence: true, if: -> { document_type.tso? }

  scope :with_relationships, -> { includes(:document_type) }
  scope :recent, -> { order(created_at: :desc) }

  after_create :generate_unique_code,
               :create_signatures,
               :save_to_json

  def orientation
    signatures.first.orientation
  end

  def filename
    academic = I18n.transliterate(orientation.academic.name.tr(' ', '_'))
    calendar = orientation.current_calendar.year_with_semester.tr('/', '_')
    "SGTCC_#{document_type.identifier}_#{academic}_#{calendar}".upcase
  end

  def all_signed?
    signatures.where(status: true).count == signatures.count
  end

  def save_to_json
    update(content: term_json_data)
  end

  # rubocop:disable Rails/SkipsModelValidations
  def save_judgment(user, params)
    json_judgment = { responsible: { id: user.id,
                                     accept: params[:accept],
                                     justification: params[:justification] } }
    request['judgment'] = json_judgment
    update_attribute(:request, request)
  end

  def update_requester_justification(params)
    new_request = request
    justification = params[:justification]
    return true if justification.blank?

    new_request['requester']['justification'] = justification
    update_attribute(:request, new_request)
  end

  # rubocop:enable Rails/SkipsModelValidations
  def status_table
    signatures.map do |signature|
      { name: signature.user.name, status: signature.status,
        role: I18n.t("signatures.users.roles.#{signature.user.gender}.#{signature.user_type}") }
    end
  end

  def requester_data(user, user_type)
    { id: user.id, name: user.name, type: user_type, justification: }
  end

  def new_orientation_data
    advisor = Professor.find(advisor_id) if advisor_id.present?
    advisor_data = { id: advisor&.id, name: advisor&.name_with_scholarity }

    { advisor: advisor_data, professorSupervisors: select_professor_supervisors,
      externalMemberSupervisors: select_external_members }
  end

  def select_professor_supervisors
    professors = Professor.find(professor_supervisor_ids)
    Orientation.new.users_to_document(professors)
  end

  def select_external_members
    external_members = ExternalMember.find(external_member_supervisor_ids)
    Orientation.new.users_to_document(external_members)
  end

  def signature_by_user(user_id, user_types)
    pending_signature = pending_signature_by_user(user_id, user_types)
    return pending_signature if pending_signature.present?

    signatures.find_by(user_id:, user_type: user_types, status: true)
  end

  def pending_signature_by_user(user_id, user_types)
    signatures.find_by(user_id:, user_type: user_types, status: false)
  end

  def term_json_data
    { orientation: orientation_data, advisor: advisor_data, title: document_type.name.upcase,
      academic: academic_data, institution: institution_data,
      document: { id:, created_at: I18n.l(created_at, format: :document) },
      professorSupervisors: orientation.professor_supervisors_to_document,
      externalMemberSupervisors: orientation.external_member_supervisors_to_document,
      examination_board: examination_board_data }
  end

  def self.by_user(user_id, user_types, status = [true, false])
    conditions = { user_id:, user_type: user_types, status: }
    distinct_query = 'DISTINCT ON (documents.id) documents.*'
    joins(:signatures).select(distinct_query).where(signatures: conditions)
  end

  private

  def create_signatures
    Documents::SaveSignatures.new(self).send("save_#{document_type.identifier}")
  end

  def generate_unique_code
    update(code: Time.now.to_i + id)
  end
end
