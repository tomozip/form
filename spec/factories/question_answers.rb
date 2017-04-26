# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question_answer do
    # user nil
    # question nil
    association :user
    association :question

    factory :text_qa do
      after(:build) do |question_answer|
        question_answer.answer_text = build(:answer_text)
      end
    end
  end
end
