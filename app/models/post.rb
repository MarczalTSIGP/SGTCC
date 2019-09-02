class Post < ApplicationRecord
  include Searchable

  searchable title: { unaccent: true }

  validates :url, presence: true
  validates :title, presence: true
  validates :fa_icon, presence: true
  validates :content, presence: true

  after_save do
    site = Site.first
    sidebar = site.sidebar
    if sidebar.present?
      new_sidebar = sidebar << select_post_object
      site.update(sidebar: new_sidebar)
    else
      site.update(sidebar: [select_post_object(1)])
    end
  end

  private

  def select_post_object(order = Post.all.size)
    { name: title, url: url, icon: fa_icon, order: order }
  end
end
