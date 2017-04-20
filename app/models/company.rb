# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :companies_users, dependent: :delete_all
  has_many :users, through: :companies_users
  has_secure_password
end
