# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    user = User.find(params[:user_id])
    @messages = user.messages.create(message_params)
    redirect_to manager_user_path(params[:user_id])
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    redirect_to manager_user_path(params[:user_id])
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
