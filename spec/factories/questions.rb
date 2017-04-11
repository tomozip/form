# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    questionnaire nil
    body "MyString"
    category 1
  end
end
