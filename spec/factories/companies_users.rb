# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :companies_user do
    company nil
    user nil
    manager 1
  end
end
