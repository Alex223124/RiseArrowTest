require 'rails_helper'
 
describe SessionsController, :type => :controller do
 
  before do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
  end
 
  describe "#create" do
      
    # data from gooogle => sessions#create
    it "should successfully create a user" do
      expect {
        post :create
      }.to change{ User.count }.by(1)
    end
    
    it "should successfully create a session" do
      session[:user_id].should be_nil
      post :create
      session[:user_id].should_not be_nil
    end
 
    it "should redirect the user to the root url" do
       post :create
       response.should redirect_to root_url
     end
 
  end
 
   describe "#destroy" do
       
     before do
       post :create
     end
  
     it "should clear the session" do
       session[:user_id].should_not be_nil
       delete :destroy
       session[:user_id].should be_nil
     end
 
     it "should redirect to the home page" do
       delete :destroy
       response.should redirect_to root_url
     end
   end
 
end