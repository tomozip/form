# frozen_string_literal: true

require 'spec_helper'

describe AnswerText do
  it 'has a valid factory' do
    expect(build(:answer_text)).to be_valid
  end

  it 'is invalid without a question_answer_id' do
    answer_text = build(:answer_text, question_answer_id: nil)
    answer_text.valid?
    expect(answer_text.errors[:question_answer_id]).to include('を入力してください')
  end

  it 'is invalid without a body' do
    answer_text = build(:answer_text, body: nil)
    answer_text.valid?
    expect(answer_text.errors[:body]).to include('を入力してください')
  end

  it 'does not allow duplicate question_answer_id' do
    question_answer = create(:question_answer)
    create(:answer_text, question_answer: question_answer)
    answer_text = build(:answer_text, question_answer: question_answer)
    answer_text.valid?
    expect(answer_text.errors[:question_answer_id]).to include('はすでに存在します')
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
