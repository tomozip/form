# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :questionnaire do
    title 'MyString'
    description 'MyString'
    status 1
  end
end
