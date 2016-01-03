class SessionsController < ApplicationController

 
  # display text and links
  def index
  end

  # login
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path, :notice => "Signed in!"
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