class Documents::SaveSignature
  attr_reader :orientation, :document_type_id, :document_id, :signature_users

  def initialize(orientation)
    @orientation = orientation
    @document_type_id = DocumentType.first&.id
    @signature_users = []
  end

  def save
    create_document
    add_signature_users
    create_signatures
  end

  private

  def create_signatures
    @signature_users.each do |user_id, user_type|
      term_of_commitment = Signature.new(
        orientation_id: @orientation.id,
        document_id: @document_id,
        user_id: user_id,
        user_type: user_type
      )
      term_of_commitment.save
    end
  end

  def create_document
    document = Document.new(content: '-', document_type_id: @document_type_id)
    document.save
    @document_id = document.id
  end

  def add_signature_users
    add_academic
    add_advisor
    add_professor_supervisors
    add_external_member_supervisors
  end

  def add_academic
    @signature_users.push([@orientation.academic.id, 'A'])
  end

  def add_advisor
    @signature_users.push([@orientation.advisor.id, 'P'])
  end

  def add_professor_supervisors
    @orientation.professor_supervisors.each do |professor_supervisor|
      @signature_users.push([professor_supervisor.id, 'P'])
    end
  end

  def add_external_member_supervisors
    @orientation.external_member_supervisors.each do |external_member_supervisor|
      @signature_users.push([external_member_supervisor.id, 'E'])
    end
  end
end
