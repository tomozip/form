class Questionnaire < ApplicationRecord
  has_many :questions, dependent: :destroy
end
