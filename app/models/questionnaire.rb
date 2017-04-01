class Questionnaire < ApplicationRecord
  has_many :questions, dependent: :destroy
  enum status: { 'editing' => 0, 'sent' => 1 }
end
