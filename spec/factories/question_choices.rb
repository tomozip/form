# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question_choice do
    question nil
    body "MyString"
  end
end
