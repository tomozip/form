# frozen_string_literal: true

class AnswerText < ApplicationRecord
  belongs_to :question_answer

  validates :qusetion_answer_id, presence: true
  validates :body, presence: true
  validates :question_answer_id, uniqueness: true
  validates :question_choice_id, uniqueness: { scope: [:question_answer_id] }

  def self.create_by_params(que_answer, question_answer_id)
    answer_text_params = que_answer.permit(:body)
    answer_text_params[:question_answer_id] = question_answer_id
    AnswerText.create(answer_text_params)
  end
end
