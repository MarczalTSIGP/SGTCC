class Post < ApplicationRecord
  include Searchable

  searchable title: { unaccent: true }

  validates :url, presence: true
  validates :title, presence: true
  validates :fa_icon, presence: true
  validates :content, presence: true

  before_save do
    self.identifier = Post.maximum('identifier').to_i + 1 if identifier.blank?
  end

  after_save do
    sidebar = site.sidebar

    if sidebar.present?
      post = sidebar.select { |item| item['identifier'] == identifier }

      if post.present?
        sidebar.delete_at(post.first['order'] - 1)
      end

      new_sidebar = sidebar << select_post_object
      site.update(sidebar: new_sidebar)
    else
      site.update(sidebar: [select_post_object(1)])
    end
  end

  after_destroy do
    sidebar = site.sidebar

    post = sidebar.select { |item| item['identifier'] == identifier }

    if post.present?
      sidebar.delete_at(post.first['order'] - 1)
    end

    site.update(sidebar: sidebar)
  end

  def site
    Site.first
  end

  private

  def select_post_object(order = Post.all.size)
    { name: title, url: url, icon: fa_icon, order: order, identifier: identifier }
  end
end
