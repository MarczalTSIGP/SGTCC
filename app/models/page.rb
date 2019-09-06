class Page < ApplicationRecord
  include Searchable

  searchable menu_title: { unaccent: true }

  validates :url,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A^[a-z-]+$\z/i,
              message: I18n.t('activerecord.errors.models.page.attributes.url.invalid_format')
            }

  validates :menu_title,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :fa_icon,
            presence: true

  validates :content,
            presence: true

  before_save do
    url.downcase!
    self.identifier = Page.maximum('identifier').to_i + 1 if identifier.blank?
  end

  after_save do
    sidebar = site.sidebar

    if sidebar.present?
      remove_from_sidebar(sidebar)
      new_sidebar = sidebar << select_page_object
      site.update(sidebar: new_sidebar)
    else
      site.update(sidebar: [select_page_object(1)])
    end
  end

  after_destroy do
    sidebar = site.sidebar
    remove_from_sidebar(sidebar)
    site.update(sidebar: sidebar)
  end

  def site
    Site.first
  end

  private

  def remove_from_sidebar(sidebar)
    page = sidebar.select { |item| item['identifier'] == identifier }
    sidebar.delete_at(page.first['order'] - 1) if page.present?
  end

  def select_page_object(order = Page.all.size)
    { name: menu_title, url: url, icon: fa_icon, order: order, identifier: identifier }
  end
end
