# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :block_user
  before_action :authenticate_admin!

  def show
    @companies = Company.all
    @companies_users = []
    @companies.each do |company|
      manager = CompaniesUser.find_by(company_id: company.id, manager: 'delegate')
      if manager.present?
        manager_name = User.find(manager.user_id).name
        @companies_users.push(manager_name)
      else
        @companies_users.push(nil)
      end
    end
  end

  private
  def block_user
    return unless user_signed_in?
    warning = '現在管理者としてログイン中です。一度ログアウトしてからユーザーログインしてください。'
    redirect_to user_path(current_user.id), alert: warning
  end
end
