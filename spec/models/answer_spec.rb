# frozen_string_literal: true

require 'spec_helper'

describe Answer do
  it 'has a valid factory' do
    expect(build(:answer)).to be_valid
  end

  it 'is invalid without a user_id' do
    answer = build(:answer, user_id: nil)
    answer.valid?
    expect(answer.errors[:user_id]).to include('を入力してください')
  end

  it 'is invalid without a questionnaire_id' do
    answer = build(:answer, questionnaire_id: nil)
    answer.valid?
    expect(answer.errors[:questionnaire_id]).to include('を入力してください')
  end

  it 'is invalid without a status' do
    answer = build(:answer, status: nil)
    answer.valid?
    expect(answer.errors[:status]).to include('を入力してください')
  end

  it 'does not allow duplicate user_id&questionnaire_id' do
    user = create(:user)
    questionnaire = create(:questionnaire)
    create(:answer, user: user, questionnaire: questionnaire)
    answer = build(:answer, user: user, questionnaire: questionnaire)
    answer.valid?
    expect(answer.errors[:user_id]).to include('はすでに存在します')
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
