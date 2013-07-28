class Cart < ActiveRecord::Base
	validates :name, :description, presence: true
	validates :name, length: { maximum: 100 }
	validates :description, length: { minimum: 25, maximum: 5000 }

	has_many :comments, dependent: :destroy

	mount_uploader :cart_picture, CartPictureUploader
end
