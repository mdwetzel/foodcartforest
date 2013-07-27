class EntryComment < ActiveRecord::Base

	validates :user_id, :entry_id, :body, presence: true
	validates :body, length: { minimum: 50, maximum: 1000 }

	belongs_to :user
	belongs_to :entry
end
