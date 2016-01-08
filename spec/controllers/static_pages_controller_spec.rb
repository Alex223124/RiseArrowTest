require 'rails_helper'
	
describe StaticPagesController, :type => :controller do

  describe "GET index" do
      
    it "should be successful" do
      get 'index'
      response.should be_success
    end
    
    it "renders the :index template" do
      get :index
      response.should render_template(:index)
    end
  end

end
