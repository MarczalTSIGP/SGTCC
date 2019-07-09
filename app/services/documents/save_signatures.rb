class Documents::SaveSignatures
  attr_reader :orientation, :document_type, :document_id, :signature_users, :signature_code

  def initialize(orientation, document_type)
    @orientation = orientation
    @document_type = document_type
    @signature_users = []
  end

  def save
    create_document
    create_signature_code
    add_signature_users
    create_signatures
  end

  private

  def create_signatures
    @signature_users.each do |user_id, user_type|
      Signature.create(
        orientation_id: @orientation.id,
        document_id: @document_id,
        user_id: user_id,
        user_type: user_type,
        signature_code_id: @signature_code.id
      )
    end
  end

  def create_signature_code
    timestamps = Time.now.to_i
    timestamps += @orientation.id
    timestamps += @document_id.to_i
    @signature_code = SignatureCode.create(code: timestamps)
  end

  def create_document
    @document_id = Document.create(content: '-', document_type_id: @document_type&.id).id
  end

  def add_signature_users
    add_academic
    add_advisor
    add_professor_supervisors
    add_external_member_supervisors
    add_responsible_institution if @orientation.institution.present? && @document_type&.tcai?
  end

  def add_academic
    @signature_users.push([@orientation.academic.id, 'AC'])
  end

  def add_advisor
    @signature_users.push([@orientation.advisor.id, 'AD'])
  end

  def add_professor_supervisors
    @orientation.professor_supervisors.each do |professor_supervisor|
      @signature_users.push([professor_supervisor.id, 'PS'])
    end
  end

  def add_external_member_supervisors
    @orientation.external_member_supervisors.each do |external_member_supervisor|
      @signature_users.push([external_member_supervisor.id, 'ES'])
    end
  end

  def add_responsible_institution
    @signature_users.push([@orientation.institution.external_member.id, 'ES'])
  end
end
