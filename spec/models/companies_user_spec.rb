# frozen_string_literal: true

require 'spec_helper'

describe CompaniesUser do
  it 'has a vlid factory' do
    expect(build(:companies_user)).to be_valid
  end

  it 'is invalid without a user_id' do
    companies_user = build(:companies_user, user_id: nil)
    companies_user.valid?
    expect(companies_user.errors[:user_id]).to include('を入力してください')
  end

  it 'is invalid without a company_id' do
    companies_user = build(:companies_user, company_id: nil)
    companies_user.valid?
    expect(companies_user.errors[:company_id]).to include('を入力してください')
  end

  it 'is invalid without a manager' do
    companies_user = build(:companies_user, manager: nil)
    companies_user.valid?
    expect(companies_user.errors[:manager]).to include('を入力してください')
  end

  context 'if eligible' do
    it 'does not allow to duplicate manager&company_id' do
      company = create(:company)
      create(:companies_user,
             company: company,
             manager: 'delegate')
      companies_user = build(:companies_user,
                             company: company,
                             manager: 'delegate')
      companies_user.valid?
      expect(companies_user.errors[:manager]).to include('はすでに存在します')
    end
  end

  context 'if ineligible' do
    it 'allow to duplicate manager&company_id' do
      company = create(:company)
      create(:companies_user,
             company: company,
             manager: 'general')
      companies_user = build(:companies_user,
                             company: company,
                             manager: 'general')
      companies_user.valid?
      expect(companies_user.errors[:manager]).not_to include('はすでに存在します')
    end
  end

  let(:user) { create :user }
  let(:company) { create :company }

  describe '.set_manager' do
    it 'returns manager' do
      manager = create :companies_user, manager: 'delegate', user: user, company: company
      expect(described_class.set_manager(company.id)).to eq manager.user
    end
  end

  let(:user) { create :user }
  let(:questionnaire) { create :questionnaire }
  let(:company) { create :company }

  describe '.prepare_member_results' do
    subject(:described_subject) { described_class.prepare_member_results(user.id, questionnaire.id) }
    let(:same_com_users) { (1..3).to_a.map { create(:companies_user, company: company).user } }
    before do
      create :companies_user, company: company, user: user
      3.times { |i| create :answer, questionnaire: questionnaire, user: same_com_users[i] }
    end

    it 'pass correct params to Answer.prepare_answer_result' do
      allow(Answer).to receive(:prepare_answer_result)
        .with(questionnaire.questions, same_com_users.pluck(:id)).and_return('done')
      expect(subject).to eq 'done'
    end

    it 'call Answer.prepare_answer_result' do
      allow(Answer).to receive(:prepare_answer_result).and_return('done')
      expect(Answer).to receive(:prepare_answer_result).once
      expect { described_subject }.not_to raise_error
    end
  end
end
