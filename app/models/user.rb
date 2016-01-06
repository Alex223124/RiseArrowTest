class User < ActiveRecord::Base
    
  has_many :incoming_messages

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
         
     
  def self.from_omniauth(access_token)
    data = access_token.info
    credentials = access_token.credentials
    user = User.where(:email => data["email"]).first
  
     unless user
         #user = User.create(name: data["name"],
         user = User.create(
            email: data["email"],
            access_token: credentials["token"],
            refresh_token: credentials["refresh_token"],
            password: Devise.friendly_token[0,20] 
         )
     end
    user
  end
  
end
