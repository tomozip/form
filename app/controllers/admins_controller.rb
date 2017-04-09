# frozen_string_literal: true

class AdminsController < ApplicationController
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
end
