# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :companies_users, dependent: :delete_all
  has_many :companies, through: :companies_users
  has_many :messages, dependent: :delete_all
  has_many :answers, dependent: :delete_all
  has_many :question_answers, dependent: :destroy
  mount_uploader :image, ImageUploader

  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :email, uniqueness: true
end
