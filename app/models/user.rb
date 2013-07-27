class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #mount_uploader :image, ImageUploader

  has_many :comments, dependent: :destroy
  has_many :entry_comments, dependent: :destroy
  has_many :entries, dependent: :destroy

  mount_uploader :avatar, ImageUploader

  validates :avatar, allow_blank: true, length: { maximum: 1.megabyte.to_i, 
  				message: "is too large (maximum size is 1MB" }

  validates_uniqueness_of :username

end
