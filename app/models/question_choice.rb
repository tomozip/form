# frozen_string_literal: true

class QuestionChoice < ApplicationRecord
  belongs_to :question
  has_many :answer_choices, dependent: :delete_all

  validates :question_id, presence: true
  validates :body, presence: true
  validates :body, uniquesness: { scope: [:question_id] }
end
