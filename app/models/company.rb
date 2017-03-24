class Company < ApplicationRecord
  has_many :companies_users
  has_many :users, through: :companies_users
end
