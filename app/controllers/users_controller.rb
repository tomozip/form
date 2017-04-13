# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :log_out_company, only: [:show]
  before_action :authenticate_user!

  def show
    position = CompaniesUser.find_by(user_id: params[:id]).manager
    if position == 'delegate'
      @messages = Message.where(user_id: params[:id])
    else
      company_id = CompaniesUser.find_by(user_id: params[:id]).company_id
      manager = CompaniesUser.find_by(company_id: company_id, manager: 'delegate')
      unless manager.nil?
        manager_id = CompaniesUser.find_by(company_id: company_id, manager: 'delegate').user_id
        @messages = Message.where(user_id: manager_id)
      end
    end
    company_id = CompaniesUser.find_by(user_id: current_user.id).company_id
    @company = Company.find(company_id)
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
    @user = User.find(params[:id])
    # 会社情報
    company_id = CompaniesUser.find_by(user_id: params[:id]).company_id
    @company = Company.find(company_id)
    # 社員一覧を表示しようとしてる。
    companies_users = CompaniesUser.where(company_id: company_id)
    @staffs = []
    companies_users.each do |companies_user|
      staff = User.find(companies_user.user_id)
      @staffs.push(staff)
    end
    # メッセージ機能
    @messages = Message.where(user_id: params[:id])
  end
end
