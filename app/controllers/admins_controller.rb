class AdminsController < ApplicationController
  def show
    @companies = Company.all
    @companies_users = []
    @companies.each do |company|
      # TODO: manager: 0のとこをちゃんと1に！
      manager = CompaniesUser.where(["company_id = ? and manager = ?", company.id, 1]).select("user_id")[0]
      if manager
        manager_name = User.find(manager.user_id).name
        @companies_users.push(manager_name)
      else
        @companies_users.push(nil)
      end
    end
  end
end
