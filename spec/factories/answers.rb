# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    user nil
    questionnaire nil
    status 1
  end
end
