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

  let(:questionnaire) { create :questionnaire }
  let(:user) { create :user }

  describe '.prepare_answer_result' do
    it 'call QuestionAnswer.prepare_que_answer_result per question' do
      expect(QuestionAnswer).to receive(:prepare_que_answer_result).exactly(3).times
      allow(QuestionAnswer).to receive(:prepare_que_answer_result).and_return('done')
      questions = (1..3).to_a.map { create :question }
      expect { described_class.prepare_answer_result(questions, (1..3).to_a) }.not_to raise_error
    end
  end

  let(:params) { { user_id: user.id.to_s, questionnaire_id: questionnaire.id.to_s, answer: answer } }

  describe '.create_with_que_answer' do
    subject(:described_subject) { described_class.create_with_que_answer(params) }
    let(:answer) { (1..3).to_a.each_with_object({}) { |i, hash| hash[i.to_s] = i } }
    before do
      allow(QuestionAnswer).to receive(:create_with_childs).and_return('done')
    end

    it 'create a new Answer whose status is "answered"' do
      expect { described_subject }.to change { user.reload.answers.count }.by(1)
      expect(user.reload.answers.find_by(questionnaire_id: questionnaire.id).status).to eq 'answered'
    end
    it 'call QuestionAnswer.create_with_childs some times' do
      expect(QuestionAnswer).to receive(:create_with_childs).exactly(3).times
      expect { described_subject }.not_to raise_error
    end
  end

  describe '.tem_create_with_que_answer' do
    subject(:described_subject) { described_class.tem_create_with_que_answer(params) }
    let(:answer) { (1..3).to_a.each_with_object({}) { |i, hash| hash[i.to_s] = i } }
    before do
      allow(QuestionAnswer).to receive(:tem_create_with_childs).and_return('done')
    end

    it 'create a new Answer whose atatus is "answering"' do
      expect { described_subject }.to change { user.reload.answers.count }.by(1)
      expect(user.reload.answers.find_by(questionnaire_id: questionnaire.id).status).to eq 'answering'
    end
    it 'call QuestionAnswer.tem_create_with_childs some times' do
      expect(QuestionAnswer).to receive(:tem_create_with_childs).exactly(3).times
      expect { described_subject }.not_to raise_error
    end
  end

  let(:answer) do
    questionnaire.questions.each_with_object({}) { |question, hash| hash[question.id.to_s] = 1 }
  end

  describe '.update_with_que_answer' do
    subject(:described_subject) { described_class.update_with_que_answer(params) }
    shared_examples 'update answer status to "answered"' do
      it do
        expect { described_subject }.to change { questionnaire.answers.find_by(user_id: user.id).status }.from('answering').to('answered')
      end
    end
    before do
      allow(QuestionAnswer).to receive(:update_with_childs).and_return('done')
      allow(QuestionAnswer).to receive(:create_with_childs).and_return('done')
      create :answer, questionnaire: questionnaire, user: user, status: 'answering'
      # questionを3つ用意。まだ答えてない
      3.times { create :question, questionnaire: questionnaire }
    end

    context 'when answered' do
      before do # 全部答える。
        3.times { |i| create :question_answer, user: user, question: questionnaire.questions[i] }
      end
      it_behaves_like 'update answer status to "answered"'
      it 'call QuestionAnswer.update_with_childs' do
        expect(QuestionAnswer).to receive(:update_with_childs).exactly(3).times
        expect { described_subject }.not_to raise_error
      end
    end

    context 'when not answered' do
      it_behaves_like 'update answer status to "answered"'
      it 'call QuestionAnswer.create_with_childs' do
        expect(QuestionAnswer).to receive(:create_with_childs).exactly(3).times
        expect { described_subject }.not_to raise_error
      end
    end
  end

  describe '.tem_update_with_que_answer' do
    subject(:described_subject) { described_class.tem_update_with_que_answer(params) }
    before do
      allow(QuestionAnswer).to receive(:tem_update_with_childs).and_return('done')
      allow(QuestionAnswer).to receive(:tem_create_with_childs).and_return('done')
      # questionを3つ用意。まだ答えてない
      3.times { create :question, questionnaire: questionnaire }
    end

    context 'when answered' do
      before do # 全部答える。
        3.times { |i| create :question_answer, user: user, question: questionnaire.questions[i] }
      end
      it 'call QuestionAnswer.tem_update_with_childs' do
        expect(QuestionAnswer).to receive(:tem_update_with_childs).exactly(3).times
        expect { described_subject }.not_to raise_error
      end
    end

    context 'when not answered' do
      it 'call QuestionAnswer.tem_create_with_childs' do
        expect(QuestionAnswer).to receive(:tem_create_with_childs).exactly(3).times
        expect { described_subject }.not_to raise_error
      end
    end
  end
end
