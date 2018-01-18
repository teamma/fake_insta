class Blog < ActiveRecord::Base
  mount_uploader :blogimage, BlogImageUploader
  # validates :title, presence: true
  # validates :content, presence: true
end
