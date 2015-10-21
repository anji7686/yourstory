class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter 
    @existing_user = request.env["omniauth.auth"]
    @valid_user = User.find_by_uid(@existing_user.uid)
    if @valid_user
      flash.notice = "Signed in!"
      if @valid_user.sign_in_count == 0 
        sign_in @valid_user, :event => :authentication 
        redirect_to edit_profile_users_path
      else
        sign_in_and_redirect @valid_user, :event => :authentication 
      end
    elsif @existing_user.provider == "twitter" && @existing_user.uid
      session[:omniauth] = request.env["omniauth.auth"]
      redirect_to new_user_registration_path(uid: @existing_user.uid)  
    else
      session["devise.user_attributes"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end
