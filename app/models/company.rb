class Company < ApplicationRecord
  has_many :companies_users, dependent: :delete_all
  has_many :users, through: :companies_users
end
