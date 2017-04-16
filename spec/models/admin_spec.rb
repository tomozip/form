# frozen_string_literal: true

require 'spec_helper'

describe Admin do
  it 'has a valid factory' do
    expect(build(:admin)).to be_valid
  end

  it 'is invalid without a name' do
    admin = build(:admin, name: nil)
    admin.valid?
    expect(admin.errors[:name]).to include('を入力してください')
  end

  it 'is invalid without a email' do
    admin = build(:admin, email: nil)
    admin.valid?
    expect(admin.errors[:email]).to include('を入力してください')
  end

  it 'is invalid without a password' do
    admin = build(:admin, password: nil)
    admin.valid?
    expect(admin.errors[:password]).to include('を入力してください')
  end

  it 'does not allow duplicate email' do
    create(:admin, email: 'same@com')
    other_admin = build(:admin, email: 'same@com')
    other_admin.valid?
    expect(other_admin.errors[:email]).to include('はすでに存在します')
  end
end
