# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :companies_user do
    association :user, :company
    # company nil
    # user nil
    manager 'general'
  end
end
