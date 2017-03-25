class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :companies_users, dependent: :delete_all
  has_many :companies, through: :companies_users
  mount_uploader :image, ImageUploader

end
