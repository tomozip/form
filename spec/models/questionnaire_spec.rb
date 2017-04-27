# frozen_string_literal: true

require 'spec_helper'

describe Questionnaire do
  # before(:each) do
  #   binding.pry
  # end
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

  describe '.prepare_questionnaire_list' do
    subject { described_class.prepare_questionnaire_list([answering_qn.id], [answered_qn.id]) }
    let(:user) { create :user }
    let(:answered_qn) { create(:answer, user: user, status: 'answered').questionnaire }
    let(:answering_qn) { create(:answer, user: user, status: 'answering').questionnaire }
    let(:not_yet_qn) { create :questionnaire }

    context 'with sent questionnaires' do
      before do
        answered_qn.update(status: 'sent')
        answering_qn.update(status: 'sent')
        not_yet_qn.update(status: 'sent')
      end
      it { is_expected.to eq(answered: [answered_qn], answering: [answering_qn], not_yet: [not_yet_qn]) }
    end

    context 'without sent questionnaires' do
      it { is_expected.to eq({}) }
    end

    # it 'returns questionnaires devided by answer status' do
    #   expect(subject[:answered]).to eq [answered_qn]
    #   expect(subject[:answering]).to eq [answering_qn]
    #   expect(subject[:not_yet]).to include not_yet_qn
    # end
    #
    # it { is_expected.to eq(answered: [answered_qn], answering: [answering_qn], not_yet: [not_yet_qn]) }
    #
    # it 'returns an empty array' do
    #   answered_qn.update(status: 'editing')
    #   answering_qn.update(status: 'editing')
    #   not_yet_qn.update(status: 'editing')
    #   expect(subject).to eq []
    # end
  end
end
