class Orientation < ApplicationRecord
  include StringHelper
  include KaminariHelper

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

  scope :recent, -> { order('calendars.year DESC, calendars.semester ASC, title, academics.name') }
  scope :with_relationships, -> { includes(:advisor, :academic, :calendar) }

  def short_title
    title.length > 35 ? "#{title[0..35]}..." : title
  end

  def self.search(term, data = all)
    return data if term.blank?
    regex_term = /#{remove_accents(term)}/i
    data.select do |orientation|
      academic = orientation.academic
      "(#{remove_accents(orientation.advisor.name)})|
       (#{remove_accents(orientation.title)})|
       (#{remove_accents(academic.name)})|
       (#{academic.ra})".match?(regex_term)
    end
  end

  def self.by_tcc_one(page, term)
    data = with_relationships.tcc_one.recent
    paginate_array(search(term, data), page)
  end

  def self.by_tcc_two(page, term)
    data = with_relationships.tcc_two.recent
    paginate_array(search(term, data), page)
  end

  def self.by_current_tcc_one(page, term)
    data = with_relationships.current_tcc_one.recent
    paginate_array(search(term, data), page)
  end

  def self.by_current_tcc_two(page, term)
    data = with_relationships.current_tcc_two.recent
    paginate_array(search(term, data), page)
  end
end
