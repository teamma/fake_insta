class Post < ActiveRecord::Base
  mount_uploader :postimage, PostImageUploader
  belongs_to :user
  # validates :postimage, presence: true
end
