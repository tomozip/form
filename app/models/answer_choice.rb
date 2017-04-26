# frozen_string_literal: true

class AnswerChoice < ApplicationRecord
  belongs_to :question_answer
  belongs_to :question_choice

  validates :question_answer_id, presence: true
  validates :question_choice_id, presence: true

  def self.create_by_params(que_answer, question_answer_id)
    answer_choice_params = que_answer.permit(:question_choice_id)
    answer_choice_params[:question_answer_id] = question_answer_id
    AnswerChoice.create!(answer_choice_params)
  end
end
