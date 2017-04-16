# frozen_string_literal: true

require 'spec_helper'

describe Admin do
  it 'is valid with a name, email and password' do
    admin = described_class.new(
      name: '島田',
      email: 'tomoki@gmail.com',
      password: 'tomoki'
    )
    expect(admin).to be_valid
  end

  it 'is invalid without a name' do
    admin = described_class.new(name: nil)
    admin.valid?
    expect(admin.errors[:name]).to include('を入力してください')
  end

  it 'is invalid without a email' do
    admin = described_class.new(email: nil)
    admin.valid?
    expect(admin.errors[:email]).to include('を入力してください')
  end

  it 'is invalid without a password' do
    admin = described_class.new(password: nil)
    admin.valid?
    expect(admin.errors[:password]).to include('を入力してください')
  end

  it 'does not allow duplicate email' do
    described_class.create(
      name: '島田',
      email: 'tomoki@gmail.com',
      password: 'tomoki'
    )
    other_admin = described_class.new(
      name: '智貴',
      email: 'tomoki@gmail.com',
      password: 'tomokinew'
    )
    other_admin.valid?
    expect(other_admin.errors[:email]).to include('はすでに存在します')
  end
end
