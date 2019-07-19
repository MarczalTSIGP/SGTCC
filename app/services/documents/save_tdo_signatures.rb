class Documents::SaveTdoSignatures
  attr_reader :orientation, :professor, :justification, :signature_users

  def initialize(orientation, professor, justification)
    @orientation = orientation
    @professor = professor
    @justification = justification
    @signature_users = []
  end

  def save
    create_tdo_signatures
  end

  private

  def create_tdo_signatures
    tdo = DocumentType.tdo.first.documents.create!(content: '-', request: select_request)
    add_signature_users
    create_signatures(tdo)
    tdo.update_content_data
    tdo
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

  def select_request
    { requester: { id: @professor.id, name: @professor.name,
                   type: 'advisor', justification: @justification } }
  end

  def add_signature_users
    add_advisor
    add_responsible
  end

  def add_advisor
    @signature_users.push([@orientation.advisor.id, 'AD'])
  end

  def add_responsible
    professor = Professor.joins(:roles).where('roles.identifier': :responsible).first
    @signature_users.push([professor.id, 'PR'])
  end
end
