class Documents::SaveSignatures
  attr_reader :orientation, :document, :signature_users

  def initialize(orientation, document)
    @orientation = orientation
    @document = document
    @signature_users = []
  end

  def save
    add_signature_users
    create_signatures
  end

  private

  def create_signatures
    @signature_users.each do |user_id, user_type|
      Signature.create(
        orientation_id: @orientation.id,
        document_id: @document.id,
        user_id: user_id,
        user_type: user_type
      )
    end
  end

  def add_signature_users
    add_academic
    add_advisor
    add_professor_supervisors
    add_external_member_supervisors
    add_responsible_institution if add_responsible_institution?
  end

  def add_responsible_institution?
    @orientation.institution.present? && @document.document_type&.tcai?
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
