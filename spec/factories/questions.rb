# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    association :questionnaire
    # questionnaire nil
    body 'MyString'
    category 1

    factory :text_question do
      category 'input'
    end
    factory :select_question do
      category 'selectbox'
      after(:build) do |question|
        3.times do |index|
          question.question_choices << build(:question_choice, body: "qc#{index}")
        end
      end
    end
    factory :checkbox_question do
      category 'checkbox'
      after(:build) do |question|
        3.times do |index|
          question.question_choices << build(:question_choice, body: "qc#{index}")
        end
      end
    end
  end
end
