# frozen_string_literal: true

require 'spec_helper'

describe Message do
  it 'is valid with a user_id and body' do
    message = described_class.new(
      user_id: 1,
      body: 'message body'
    )
    expect(message).to be_valid
  end

  it 'is invalid without a user_id' do
    message = described_class.new(user_id: nil)
    message.valid?
    expect(message.errors[:user_id]).to include("can't be blank")
  end

  it 'is invalid without a body' do
    message = described_class.new(body: nil)
    message.valid?
    expect(message.errors[:body]).to include("can't be blank")
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
