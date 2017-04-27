# frozen_string_literal: true

require 'spec_helper'

describe Message do
  it 'has a valid factory' do
    expect(build(:message)).to be_valid
  end

  it 'is invalid without a user_id' do
    message = build(:message,
                    user_id: nil)
    message.valid?
    expect(message.errors[:user_id]).to include('を入力してください')
  end

  it 'is invalid without a body' do
    message = build(:message,
                    body: nil)
    message.valid?
    expect(message.errors[:body]).to include('を入力してください')
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
