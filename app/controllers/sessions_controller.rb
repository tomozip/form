# frozen_string_literal: true

class SessionsController < ApplicationController
  def after_update_path_for(_resource)
    mypage_user_path(current_user.id)
  end

  def new
    @companies = Company.all.select(:id, :name)
  end

  def create
    company = Company.find_by(id: params[:session][:company_id])
    if company && company.authenticate(params[:session][:password])
      # 会社ログイン後にユーザー登録のページにリダイレクトする
      log_in_company company
      redirect_to new_user_registration_path
    else
      flash.now[:alert] = 'パスワードが間違っています。'
      @companies = Company.all.select(:id, :name)
      render 'new'
    end
  end

  def destroy
    log_out_company
    redirect_to new_user_session_path
  end
end
