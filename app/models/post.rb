class Post < ApplicationRecord
  include Searchable

  searchable title: { unaccent: true }

  validates :url,
            presence: true,
            uniqueness: true

  validates :title,
            presence: true,
            uniqueness: true

  validates :fa_icon,
            presence: true

  validates :content,
            presence: true

  before_save do
    self.identifier = Post.maximum('identifier').to_i + 1 if identifier.blank?
  end

  after_save do
    sidebar = site.sidebar

    if sidebar.present?
      remove_from_sidebar(sidebar)
      new_sidebar = sidebar << select_post_object
      site.update(sidebar: new_sidebar)
    else
      site.update(sidebar: [select_post_object(1)])
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
    post = sidebar.select { |item| item['identifier'] == identifier }
    sidebar.delete_at(post.first['order'] - 1) if post.present?
  end

  def select_post_object(order = Post.all.size)
    { name: title, url: url, icon: fa_icon, order: order, identifier: identifier }
  end
end
