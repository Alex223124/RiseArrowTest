require 'rails_helper'
 
describe IncomingMessagesController, :type => :controller do
 
  before(:each)  do
    user = FactoryGirl.create(:user, :email => "example#{Random.rand(12423)}@example.com", :password => '123123123')
    session[:user_id] = user.id
    incoming_message = FactoryGirl.create(:incoming_message, :id => 0, :user_id => user.id)
  end
 
 
    describe "GET #index" do
    
      it "returns http success" do
        get :index
        response.should be_success
      end
    
      it "should render_template :index" do
        get :index
        expect(response).to render_template :index
      end
    end
    
        
    describe "GET #show" do
        
      it "returns http success" do
        get :show, :id => 0
        response.should be_success
      end
      
      it "should render_template :show" do
        get :show, :id => 0
        expect(response).to render_template :show
      end
    end
    
    
    describe "DELETE #destroy" do
      
      it "shoud detele message" do
        delete :destroy, :id => 0
        response.should redirect_to incoming_messages_path
      end
    end
    
end


