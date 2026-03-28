class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  include Pagy::Backend

  allow_browser versions: :modern

  rescue_from Pundit::NotAuthorizedError, with: :handle_not_authorized

  helper_method :current_user

  def current_user
    Current.session&.user
  end

  private

  def handle_not_authorized
    redirect_to root_path, alert: "You don't have permission to access this page."
  end
end
