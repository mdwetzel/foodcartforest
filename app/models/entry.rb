class Entry < ActiveRecord::Base

	validates :title, :body, :user_id, presence: true
	validates :title, length: { minimum: 5, maximum: 100 }
	validates :body, length: { minimum: 50, maximum: 10000 }

	belongs_to :user
end
