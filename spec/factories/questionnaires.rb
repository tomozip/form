# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :questionnaire do
    title 'MyString'
    description 'MyString'
    status 'editing'

    # after(:build) do |questionnaire|
    #   %i[text_question select_question checkbox_question].each do |question|
    #     questionnaire.questions << build(question)
    #   end
    # end
  end
end
