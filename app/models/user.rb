class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :companies_users, dependent: :delete_all
  has_many :companies, through: :companies_users
  has_many :messages, dependent: :delete_all
  has_many :answers, dependent: :delete_all
  mount_uploader :image, ImageUploader
end
