# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer_text do
    association :question_answer
    # question_answer nil
    body 'MyString'
  end
end
