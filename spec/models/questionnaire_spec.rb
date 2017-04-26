# frozen_string_literal: true

require 'spec_helper'

describe Questionnaire do
  it 'has a valid factory' do
    expect(build(:questionnaire)).to be_valid
  end

  it 'is invalid without a title' do
    questionnaire = build(:questionnaire, title: nil)
    questionnaire.valid?
    expect(questionnaire.errors[:title]).to include('を入力してください')
  end

  it 'is invalid without a description' do
    questionnaire = build(:questionnaire, description: nil)
    questionnaire.valid?
    expect(questionnaire.errors[:description]).to include('を入力してください')
  end

  it 'is invalid without a status' do
    questionnaire = build(:questionnaire, status: nil)
    questionnaire.valid?
    expect(questionnaire.errors[:status]).to include('を入力してください')
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
