class CompaniesUsersController < ApplicationController
  def index
    @company = Company.find(params[:company_id])
    @companies_users = CompaniesUser.where(company_id: params[:company_id])
    @users = []
    @companies_users.each do |companies_user|
      user = User.find(companies_user.user_id)
      @users.push({info: user, manager: companies_user.manager, companies_user_id: companies_user.id})
    end
  end

  def changeManager
    # 現代表者update
    present_manager = CompaniesUser.find_by(company_id: params[:company_id], manager: 'delegate')
    present_manager.update_attribute(:manager, 'general')
    # 代表者add
    new_manager = CompaniesUser.find(params[:id])
    new_manager.update_attribute(:manager, 'delegate')
    redirect_to company_companies_users_path(params[:company_id])
  end

  private
    def companies_user_params
      params.require(:companies_user).permit(:user_id, :company_id, :manager)
    end
end
