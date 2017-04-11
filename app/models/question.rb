class Question < ApplicationRecord
  belongs_to :questionnaire
  has_many :question_choices, dependent: :delete_all
  enum category: { 'input' => 0, 'textarea' => 1, 'checkbox' => 2, 'selectbox' => 3, 'radio' => 4 }
  validates :category, presence: true
  validates :questionnaire_id, presence: true
  validates :body, presence: true
end
