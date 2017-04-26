# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :block_user
  before_action :authenticate_admin!

  def show
    @companies = Company.all
    @companies_users = @companies.map do |company|
      manager = company.companies_users.find_by(manager: 'delegate')
      manager.try(:user).try(:name)
    end
  end

  private

  def block_user
    return unless user_signed_in?
    warning = '現在管理者としてログイン中です。一度ログアウトしてからユーザーログインしてください。'
    redirect_to user_path(current_user.id), alert: warning
  end
end
