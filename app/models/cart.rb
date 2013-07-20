class Cart < ActiveRecord::Base
	validates :name, :description, presence: true
	validates :name, length: { maximum: 100 }
	validates :description, length: { minimum: 25, maximum: 5000 }


end
