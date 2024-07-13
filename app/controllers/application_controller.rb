class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_public_key

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:nickname, :first_name, :last_name, :first_name_kana, :last_name_kana, :birthday])
  end

  def set_public_key
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
  end
end
