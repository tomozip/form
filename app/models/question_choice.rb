class QuestionChoice < ApplicationRecord
  belongs_to :question
  validates :question_id, presence: true
  validates :body, presence: true
end
