class UsersController < ApplicationController
  def show

  end

  def mypage
    @user = User.find(params[:id])
  end
end
