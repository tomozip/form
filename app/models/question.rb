# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :questionnaire
  has_many :question_choices, dependent: :delete_all
  has_many :question_answers, dependent: :destroy
  enum category: { 'input' => 0, 'textarea' => 1, 'checkbox' => 2, 'selectbox' => 3, 'radio' => 4 }

  validates :questionnaire_id, presence: true
  validates :body, presence: true
  validates :category, presence: true
  validates :category, inclusion: { in: Question.categories.keys }
end
