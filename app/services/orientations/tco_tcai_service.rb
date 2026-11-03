module Orientations
  class TcoTcaiService
    def self.create(orientation)
      new(orientation).create
    end

    def self.recreate(orientation)
      new(orientation).recreate
    end

    def initialize(orientation)
      @orientation = orientation
    end

    def create
      params = { orientation_id: @orientation.id }
      create_tco(params)
      create_tcai(params)
    end

    def recreate
      return unless @orientation.tcc_one? && @orientation.can_be_edited?

      @orientation.destroy_document(@orientation.tco) if @orientation.tco?
      @orientation.destroy_document(@orientation.tcai) if @orientation.tcai?
      create
    end

    private

    def create_tco(params)
      DocumentType.find_by(identifier: :tco).documents.create!(params)
    end

    def create_tcai(params)
      return if @orientation.institution.blank?

      DocumentType.find_by(identifier: :tcai).documents.create!(params)
    end
  end
end
