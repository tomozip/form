# frozen_string_literal: true

require 'spec_helper'

describe User do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a name' do
    user = build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include('を入力してください')
  end

  it 'is invalid without a email' do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include('を入力してください')
  end

  it 'is invalid without a password' do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include('を入力してください')
  end

  it 'does not allow duplicate email' do
    create(:user, email: 'same@com')
    user = build(:user, email: 'same@com')
    user.valid?
    expect(user.errors[:email]).to include('はすでに存在します')
  end

  pending "add some examples to (or delete) #{__FILE__}"
end
