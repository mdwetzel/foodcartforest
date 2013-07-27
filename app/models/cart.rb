class Cart < ActiveRecord::Base
	validates :name, :description, presence: true
	validates :name, length: { maximum: 100 }
	validates :description, length: { minimum: 25, maximum: 5000 }

	has_many :comments, dependent: :destroy
	has_many :hours_of_operation, dependent: :destroy

	accepts_nested_attributes_for :hours_of_operation
end
