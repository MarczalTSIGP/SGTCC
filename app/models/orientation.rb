class Orientation < ApplicationRecord
  include Searchable

  searchable title: { unaccent: true }

  belongs_to :calendar
  belongs_to :academic
  belongs_to :advisor, class_name: 'Professor', inverse_of: :orientations
  belongs_to :institution, optional: true

  has_many :orientation_supervisors,
           dependent: :restrict_with_error

  has_many :professor_supervisors,
           class_name: 'Professor',
           foreign_key: :professor_supervisor_id,
           through: :orientation_supervisors

  has_many :external_member_supervisors,
           class_name: 'ExternalMember',
           foreign_key: :external_member_supervisor_id,
           through: :orientation_supervisors

  validates :title, presence: true

  scope :tcc_one, -> { joins(:calendar).where(calendars: { tcc: Calendar.tccs[:one] }) }
  scope :tcc_two, -> { joins(:calendar).where(calendars: { tcc: Calendar.tccs[:two] }) }

  scope :current_tcc_one, lambda {
    joins(:calendar).where(calendars: { tcc: Calendar.tccs[:one],
                                        year: Calendar.current_year,
                                        semester: Calendar.current_semester })
  }

  scope :current_tcc_two, lambda {
    joins(:calendar).where(calendars: { tcc: Calendar.tccs[:two],
                                        year: Calendar.current_year,
                                        semester: Calendar.current_semester })
  }

  def short_title
    title.length > 35 ? "#{title[0..35]}..." : title
  end

  def self.by_tcc_one(page, term)
    Orientation.tcc_one
               .page(page)
               .search(term)
               .includes(:advisor, :academic, :calendar)
               .order(created_at: :desc)
  end

  def self.by_tcc_two(page, term)
    Orientation.tcc_two
               .page(page)
               .search(term)
               .includes(:advisor, :academic, :calendar)
               .order(created_at: :desc)
  end

  def self.by_current_tcc_one(page, term)
    Orientation.current_tcc_one
               .page(page)
               .search(term)
               .includes(:advisor, :academic, :calendar)
               .order('academics.name')
  end

  def self.by_current_tcc_two(page, term)
    Orientation.current_tcc_two
               .page(page)
               .search(term)
               .includes(:advisor, :academic, :calendar)
               .order('academics.name')
  end
end
