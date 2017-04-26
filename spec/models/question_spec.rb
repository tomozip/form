# frozen_string_literal: true

require 'spec_helper'

describe Question do
  it 'has a valid factory' do
    expect(build(:question)).to be_valid
  end

  it 'is invalid without a questionnaire_id' do
    question = build(:question, questionnaire_id: nil)
    question.valid?
    expect(question.errors[:questionnaire_id]).to include('を入力してください')
  end

  it 'is invalid without a body' do
    question = build(:question, body: nil)
    question.valid?
    expect(question.errors[:body]).to include('を入力してください')
  end

  it 'is invalid without a category' do
    question = build(:question, category: nil)
    question.valid?
    expect(question.errors[:category]).to include('を入力してください')
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
