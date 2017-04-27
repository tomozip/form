# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true
end
