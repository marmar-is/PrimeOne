class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_tasks

  protected
  def devise_parameter_sanitizer
    if resource_class == User
      UserParams.new(User, :user, params)
    else
      super # Use the default one
    end
  end

  private
  def set_tasks
    if user_signed_in?
      @notifs = current_user.notifs.where(seen: false)
    end
  end
end
