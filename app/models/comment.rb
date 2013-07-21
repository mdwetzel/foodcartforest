class Comment < ActiveRecord::Base

	validates :user_id, :cart_id, :body, presence: true
	validates :body, length: { minimum: 50, maximum: 1000 }

	belongs_to :user
	belongs_to :cart
end
