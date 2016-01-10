class SessionsController < ApplicationController

  # login
  def create
    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    IncomingMessage.refresh_for(current_user)
    redirect_to incoming_messages_path, :notice => "Signed in!"
  end
 
  # logout
  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "Signed out!"
  end
 
  def failure
   render :text => "Sorry, but you didn't allow access to our app!"
  end

 
end