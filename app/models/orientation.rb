class Orientation < ApplicationRecord
  include Searchable

  searchable title: { unaccent: true }

  belongs_to :calendar
  belongs_to :academic
  belongs_to :advisor, class_name: 'Professor', inverse_of: :orientations
  belongs_to :institution, optional: true

  has_many :orientation_supervisors,
           dependent: :delete_all

  has_many :professor_supervisors,
           class_name: 'Professor',
           foreign_key: :professor_supervisor_id,
           through: :orientation_supervisors,
           dependent: :destroy

  has_many :external_member_supervisors,
           class_name: 'ExternalMember',
           foreign_key: :external_member_supervisor_id,
           through: :orientation_supervisors,
           dependent: :destroy

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

  scope :recent, -> { order('calendars.year DESC, calendars.semester ASC, title') }
  scope :order_by_academic, -> { order('academics.name') }
  scope :with_relationships, -> { includes(:advisor, :academic, :calendar) }

  def short_title
    title.length > 35 ? "#{title[0..35]}..." : title
  end

  def self.by_tcc(data, page, term)
    data.page(page).search(term).with_relationships
  end

  def self.by_tcc_one(page, term)
    by_tcc(tcc_one, page, term).recent
  end

  def self.by_tcc_two(page, term)
    by_tcc(tcc_two, page, term).recent
  end

  def self.by_current_tcc_one(page, term)
    by_tcc(current_tcc_one, page, term).order_by_academic
  end

  def self.by_current_tcc_two(page, term)
    by_tcc(current_tcc_two, page, term).order_by_academic
  end
end
