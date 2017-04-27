require 'spec_helper'

describe Company do
  it 'has a valid factory' do
    expect(build(:company)).to be_valid
  end

  it 'is invalid without a password' do
    company = build(:company, password: nil)
    company.valid?
    expect(company.errors[:password]).to include('を入力してください')
  end

  it 'is invalid without a name' do
    company = build(:company, name: nil)
    company.valid?
    expect(company.errors[:name]).to include('を入力してください')
  end

  it 'does not allow duplicate name' do
    create(:company, name: 'same_name')
    company = build(:company, name: 'same_name')
    company.valid?
    expect(company.errors[:name]).to include('はすでに存在します')
  end

  pending "add some examples to (or delete) #{__FILE__}"
end
