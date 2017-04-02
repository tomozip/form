class AnswerChoice < ApplicationRecord
  belongs_to :question_answer
  belongs_to :question_choice
end
