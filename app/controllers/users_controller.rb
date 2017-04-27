# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :log_out_company, only: [:show]
  before_action :block_admin
  before_action :authenticate_user!

  def show
    company_id = CompaniesUser.find_by(user_id: current_user.id).company_id
    @company = Company.find(company_id)
    @manager = CompaniesUser.set_manager(company_id)
    @messages = Message.where(user_id: @manager.id).order('created_at DESC') if @manager.present?
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to manager_user_path(current_user.id)
  end

  def mypage
    @user = User.find(params[:id])
  end

  def manager
    @company = current_user.companies_user.company
    @staffs = @company.companies_users.map { |companies_user| companies_user.user }
    @messages = Message.where(user_id: current_user.id).order('created_at DESC')
  end

  private

  def block_admin
    return unless admin_signed_in?
    warning = '現在管理者としてログイン中です。一度ログアウトしてからユーザーログインしてください。'
    redirect_to admin_path(current_admin.id), alert: warning
  end
end
