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
  pending "add some examples to (or delete) #{__FILE__}"
end
