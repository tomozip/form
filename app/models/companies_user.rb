# frozen_string_literal: true

class CompaniesUser < ApplicationRecord
  belongs_to :company
  belongs_to :user
  enum manager: { general: 0, delegate: 1 }
end
