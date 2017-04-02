class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :questionnaire
  enum status: { 'answering' => 0, 'answered' => 1 }
  validates :user_id, :uniqueness => { :scope => :questionnaire_id }
end
