class Documents::SaveSignatures
  attr_reader :orientation, :signature_users

  def initialize(orientation)
    @orientation = orientation
    @signature_users = []
  end

  def save
    create_tco_signatures
    create_tcai_signatures if @orientation.institution.present?
  end

  private

  def create_tco_signatures
    tco = DocumentType.tco.first.documents.create!(content: '{}')
    add_signature_users(tco)
    create_signatures(tco)
    tco.update_content_data
  end

  def create_tcai_signatures
    tcai = DocumentType.tcai.first.documents.create!(content: '{}')
    @signature_users = []
    add_signature_users(tcai)
    create_signatures(tcai)
    tcai.update_content_data
  end

  def create_signatures(document)
    @signature_users.each do |user_id, user_type|
      @orientation.signatures << Signature.create!(
        orientation_id: @orientation.id,
        document_id: document.id,
        user_id: user_id,
        user_type: user_type
      )
    end
  end

  def add_signature_users(document)
    add_academic
    add_advisor
    add_professor_supervisors
    add_external_member_supervisors
    add_responsible_institution if add_responsible_institution?(document)
  end

  def add_responsible_institution?(document)
    document.document_type.tcai?
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
