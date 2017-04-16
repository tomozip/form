# frozen_string_literal: true

require 'spec_helper'

describe AnswerChoice do
  it 'has a valid factory' do
    expect(build(:answer_choice)).to be_valid
  end

  it 'is invalid without a questionnaire_id' do
    answer_choice = build(:answer_choice, questionnaire_id: nil)
    answer_choice.valid?
    expect(answer_choice.errors[:questionnaire_id]).to include('を入力してください')
  end

  it 'is invalid without a question_choice_id' do
    answer_choice = build(:answer_choice, question_choice_id: nil)
    answer_choice.valid?
    expect(answer_choice.errors[:question_choice_id]).to include('を入力してください')
  end

  pending "add some examples to (or delete) #{__FILE__}"
end
