# frozen_string_literal: true

class CompaniesUsersController < ApplicationController
  def index
    @company = Company.find(params[:company_id])
    @companies_users = CompaniesUser.where(company_id: params[:company_id])
    @users = []
    @has_manager = false
    @companies_users.each do |companies_user|
      @has_manager = true if companies_user.manager == 'delegate'
      @users.push(
        info: companies_user.user,
        manager: companies_user.manager,
        companies_user_id: companies_user.id
      )
    end
  end

  def change_manager
    present_manager = CompaniesUser.find_by(company_id: params[:company_id], manager: 'delegate')
    present_manager.update(manager: 'general')
    new_manager = CompaniesUser.find(params[:id])
    new_manager.update(manager: 'delegate')
    redirect_to company_companies_users_path(params[:company_id])
  end

  def registar_manager
    new_manager = CompaniesUser.find(params[:id])
    new_manager.update(manager: 'delegate')
    redirect_to company_companies_users_path(params[:company_id])
  end
end
