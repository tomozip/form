class Questionnaire < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :delete_all
  enum status: { 'editing' => 0, 'sent' => 1 }
end
