require 'rails_helper'

describe User do
  it "is valid with email and pssword" do
	  user = create(:user, :password => 11111131313)
		expect(user).to be_valid
	end
end