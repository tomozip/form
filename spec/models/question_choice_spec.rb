# frozen_string_literal: true

require 'spec_helper'

describe QuestionChoice do
  it 'has a valid factory' do
    expect(build(:question_choice)).to be_valid
  end

  it 'is invalid without a question_id' do
    question_choice = build(:question_choice, question_id: nil)
    question_choice.valid?
    expect(question_choice.errors[:question_id]).to include('を入力してください')
  end

  it 'is invalid without a body' do
    question_choice = build(:question_choice, body: nil)
    question_choice.valid?
    expect(question_choice.errors[:body]).to include('を入力してください')
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
