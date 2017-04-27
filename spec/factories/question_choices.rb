# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question_choice do
    association :question
    # question nil
    body 'MyString'
  end
end
