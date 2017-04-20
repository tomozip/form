class QuestionAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :answer_texts, dependent: :delete_all
  has_many :answer_choices, dependent: :delete_all
end
