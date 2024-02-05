class OrientationsInTccOneSerializer < OrientationsSerializer
  attribute :title do |object|
    if object.final_proposal
      object.final_proposal.title
    else
      object.title
    end
  end

  attribute :summary do |object|
    if object.final_proposal
      object.final_proposal.summary
    else
      ''
    end
  end

  attribute :approved_date do |object|
    if object.final_proposal
      approved_date(object, :proposal)
    else
      ''
    end
  end

  attribute :documents do |object|
    documents(object)
  end

  def self.documents(object)
    docs = []
    final_proposal(object, docs)
    docs
  end

  def self.final_proposal(object, docs)
    return if object.final_proposal.nil?

    docs << {
      name: 'Proposta',
      url: object.final_proposal.pdf.url
    }
  end
end
