class Documents::SaveSignatures
  include DefenseMinutes
  attr_reader :document, :signature_users

  def initialize(document)
    @document = document
    @orientation = Orientation.find(document.orientation_id)
    @signature_users = []
  end

  def save_tco
    add_signature_users
    create_signatures
  end

  def save_tcai
    @signature_users = []
    add_signature_users
    create_signatures
  end

  def save_tdo
    add_advisor
    add_responsible
    create_signatures
  end

  def save_tep
    add_academic
    add_coordinator
    add_advisor
    add_responsible
    create_signatures
  end

  def save_tso
    add_academic
    add_advisor
    add_new_advisor
    add_responsible
    create_signatures
  end

  private

  def create_signatures
    @signature_users.each do |user_id, user_type|
      @orientation.signatures << Signature.create!(
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
    @document.document_type.tcai?
  end

  def add_academic
    @signature_users.push([@orientation.academic.id, 'AC'])
  end

  def add_advisor
    @signature_users.push([@orientation.advisor.id, 'AD'])
  end

  def add_new_advisor
    new_advisor = @document.request['new_orientation']['advisor']
    @signature_users.push([new_advisor['id'], 'NAD'])
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

  def add_coordinator
    @signature_users.push([Professor.current_coordinator.id, 'CC'])
  end

  def add_responsible
    professor_id = Professor.current_responsible.id
    @signature_users.push([professor_id, 'PR'])
  end
end
