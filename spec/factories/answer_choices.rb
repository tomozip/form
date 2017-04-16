# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer_choice do
    association :question_answer
    association :question_choice
    # question_answer nil
    # question_choice nil
  end
end
