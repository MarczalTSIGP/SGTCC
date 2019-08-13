class Document < ApplicationRecord
  include TermJsonData
  include SignatureMark

  attr_accessor :orientation_id, :advisor_id, :justification,
                :professor_supervisor_ids, :external_member_supervisor_ids

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

  def all_signed?
    signatures.where(status: true).count == signatures.count
  end

  def save_to_json
    update(content: term_json_data)
  end

  def save_judgment(user, params)
    json_judgment = { responsible: { id: user.id,
                                     accept: params[:accept],
                                     justification: params[:justification] } }
    request['judgment'] = json_judgment
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(:request, request)
    # rubocop:enable Rails/SkipsModelValidations
  end

  def status_table
    signatures.map do |signature|
      { name: signature.user.name, status: signature.status,
        role: I18n.t("signatures.users.roles.#{signature.user.gender}.#{signature.user_type}") }
    end
  end

  def requester_data(user, user_type)
    { id: user.id, name: user.name, type: user_type, justification: justification }
  end

  def new_orientation_data
    advisor = Professor.find(advisor_id) if advisor_id.present?
    advisor_data = { id: advisor&.id, name: advisor&.name_with_scholarity }

    { advisor: advisor_data, professorSupervisors: select_professor_supervisors,
      externalMemberSupervisors: select_external_members }
  end

  def select_professor_supervisors
    professors = Professor.find(professor_supervisor_ids)
    Orientation.new.supervisors_to_document(professors)
  end

  def select_external_members
    external_members = ExternalMember.find(external_member_supervisor_ids)
    Orientation.new.supervisors_to_document(external_members)
  end

  def filename
    academic = I18n.transliterate(orientation.academic.name.tr(' ', '_'))
    calendar = orientation.calendar.year_with_semester.tr('/', '_')
    "SGTCC_#{document_type.identifier}_#{academic}_#{calendar}".upcase
  end

  def signature_by_user(user_id, user_types)
    pending_signature = pending_signature_by_user(user_id, user_types)
    return pending_signature if pending_signature.present?
    signatures.find_by(user_id: user_id, user_type: user_types, status: true)
  end

  def pending_signature_by_user(user_id, user_types)
    signatures.find_by(user_id: user_id, user_type: user_types, status: false)
  end

  def self.by_user(user_id, user_types, status = [true, false])
    conditions = { user_id: user_id, user_type: user_types, status: status }
    distinct_query = 'DISTINCT ON (documents.id) documents.*'
    joins(:signatures).select(distinct_query).where(signatures: conditions)
  end

  def self.new_tdo(professor, params = {})
    document = DocumentType.find_by(identifier: :tdo).documents.new(params)
    new_request(professor, 'advisor', document)
  end

  def self.new_tep(academic, params = {})
    params[:orientation_id] = academic.current_orientation_tcc_two.first.id
    document = DocumentType.find_by(identifier: :tep).documents.new(params)
    new_request(academic, 'academic', document)
  end

  def self.new_tso(academic, params = {})
    params[:orientation_id] = academic.current_orientation.id
    params[:professor_supervisor_ids].shift
    params[:external_member_supervisor_ids].shift

    document = DocumentType.find_by(identifier: :tso).documents.new(params)
    new_orientation_request(academic, 'academic', document)
  end

  def self.new_orientation_request(user, user_type, document)
    document.request = { requester: document.requester_data(user, user_type),
                         new_orientation: document.new_orientation_data }
    document
  end

  def self.new_request(user, user_type, document)
    document.request = { requester: document.requester_data(user, user_type) }
    document
  end

  private

  def create_signatures
    Documents::SaveSignatures.new(self).send("save_#{document_type.identifier}")
  end

  def generate_unique_code
    update(code: Time.now.to_i + id)
  end
end
