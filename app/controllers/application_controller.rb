
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :set_locale

  private
    # Verify if a user is logged in. Otherwise redirect.
      def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = t(:login_first)
          redirect_to login_url
        end
      end

    # Set language based on url
    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end
end
