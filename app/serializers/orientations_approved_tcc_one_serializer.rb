class OrientationsApprovedTccOneSerializer < OrientationsSerializer
  attribute :title do |object|
    object.final_project.title
  end

  attribute :summary do |object|
    object.final_project.summary
  end

  attribute :approved_date do |object|
    approved_date(object, :project)
  end

  attribute :documents do |object|
    documents(object)
  end

  def self.documents(object)
    docs = []
    final_project(object, docs)
    final_proposal(object, docs)
    docs
  end

  def self.final_project(object, docs)
    return if object.final_project.nil?

    docs << {
      name: 'Projeto',
      url: object.final_project.pdf.url
    }
  end

  def self.final_proposal(object, docs)
    return if object.final_proposal.nil?

    docs << {
      name: 'Proposta',
      url: object.final_proposal.pdf.url
    }
  end
end
