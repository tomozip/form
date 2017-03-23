class AdminsController < ApplicationController
  def show
    @companies = Company.all
    @companies.each do |company|
      company["delegate"] = CompanyUser.where(company_id: company.id)
    end
  end
end
