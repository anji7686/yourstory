class RegistrationsController < Devise::RegistrationsController
  
 def create
    if session[:omniauth]
  	  if params[:uid].present?
         User.from_omniauth_twitter(session[:omniauth],params[:user][:email])
         @user = User.find_by_uid(params[:uid])
         session[:omniauth] = nil
  		    if @user.persisted?
  			    sign_in_and_redirect @user,:event => :authentication 
  		    else
            flash.alert = "You should logged in!!"
            redirect_to new_user_registration_url
          end    
      else
        flash.alert = "You should logged in!!"
        redirect_to new_user_registration_url
      end
  	else
      super
  	end
  end

protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

end