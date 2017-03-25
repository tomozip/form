class UsersController < ApplicationController
  def show
    @position = CompaniesUser.find_by(user_id: params[:id]).manager
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
    # 社員一覧を表示しようとしてる。
    company_id = CompaniesUser.find_by(user_id: params[:id]).company_id
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
