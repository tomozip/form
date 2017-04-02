class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :questionnaire
  enum status: { 'answering' => 0, 'answered' => 1 }
end
