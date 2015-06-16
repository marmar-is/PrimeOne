# app/controllers/concerns/user_params.rb
class UserParams < Devise::ParameterSanitizer
  def sign_in
    default_params.permit(:email, :password, :remember_me)
  end

  def sign_up
    default_params.permit(:fname, :lname, :email,
    :password, :password_confirmation)
  end

  def account_update
    default_params.permit(:fname, :lname, :email,
    :password, :password_confirmation, :current_password)
  end

end
