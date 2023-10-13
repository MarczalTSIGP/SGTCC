class OrientationsApprovedSerializer < OrientationsSerializer
  attribute :title do |object|
    object.final_monograph.title
  end

  attribute :summary do |object|
    object.final_monograph.summary
  end

  attribute :approved_date do |object|
    approved_date(object, :monograph)
  end

  attribute :documents do |object|
    documents(object)
  end

  def self.documents(object)
    docs = []
    final_monograph(object, docs)
    complementary_files(object, docs)
    docs.reject { |doc| doc[:url].nil? }
  end

  def self.final_monograph(object, docs)
    return if object.final_monograph.nil?

    docs << {
      name: 'Monografia',
      url: object.final_monograph.pdf.url
    }
  end

  def self.complementary_files(object, docs)
    return if object.final_monograph.nil?
    return if object.final_monograph.complementary_files.nil?
  
      docs << {
        name: 'Arquivos complementares',
        url: object.final_monograph.complementary_files.url
      }
  end
end
