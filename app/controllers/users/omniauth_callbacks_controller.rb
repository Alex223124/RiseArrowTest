class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    
  def google_oauth2
    
      @auth_hash = request.env['omniauth.auth']
      auth_user_params = @auth_hash
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(auth_user_params)
      
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
  end
  
      
end
