# frozen_string_literal: true

class QuestionChoice < ApplicationRecord
  belongs_to :question
  has_many :answer_choices, dependent: :delete_all
end
