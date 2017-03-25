class SessionsController < ApplicationController
  def new
    @companies = Company.all.select(:id, :name)
  end

  def create
    company = Company.find_by(id: params[:session][:company_id])
    if company && company.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in company
      redirect_to new_user_registration_path
    else
      flash.now[:danger] = "パスワードが正しくありません" # 本当は正しくない
      @companies = Company.all.select(:id, :name)
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to new_user_session_path
  end
end
