class CompaniesController < ApplicationController
  def create
    @company = Company.create(company_params)
    redirect_to admin_path(current_admin.id)
  end

  private
    def company_params
      params.require(:company).permit(:name, :password)
    end
end
