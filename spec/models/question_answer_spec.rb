# frozen_string_literal: true

require 'spec_helper'

describe QuestionAnswer do
  it 'has a valid factory' do
    expect(build(:question_answer)).to be_valid
  end

  it 'is invalid without a question_id' do
    question_answer = build(:question_answer, question_id: nil)
    question_answer.valid?
    expect(question_answer.errors[:question_id]).to include('を入力してください')
  end

  it 'is invalid without a user_id' do
    question_answer = build(:question_answer, user_id: nil)
    question_answer.valid?
    expect(question_answer.errors[:user_id]).to include('を入力してください')
  end

  it 'does not allow duplicate user_id&question_id' do
    user = create(:user)
    question = create(:question)
    create(:question_answer, user: user, question: question)
    question_answer = build(:question_answer, user: user, question: question)
    question_answer.valid?
    expect(question_answer.errors[:user_id]).to include('はすでに存在します')
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
