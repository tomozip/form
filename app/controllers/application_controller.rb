# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[image name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[image name])
  end
end
