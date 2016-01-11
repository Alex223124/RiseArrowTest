require 'net/http'
require 'json'

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
       user = User.create(
          email: data["email"],
          access_token: credentials["token"],
          refresh_token: credentials["refresh_token"],
          expires_at: Time.at(credentials["expires_at"]).to_datetime,
          password: Devise.friendly_token[0,20] 
         )
    end
      user
  end
  

  def to_params
    {'refresh_token' => refresh_token,
    'client_id' => ENV['CLIENT_ID'],
    'client_secret' => ENV['CLIENT_SECRET'],
    'grant_type' => 'refresh_token'}
  end
  
 
  def request_token_from_google
    url = URI("https://accounts.google.com/o/oauth2/token")
    Net::HTTP.post_form(url, self.to_params)
  end
 
  def refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    update_attributes(
    access_token: data['access_token'],
    expires_at: Time.now + (data['expires_in'].to_i).seconds)
  end
 
  def expired?
    expires_at < Time.now
  end
 
  def fresh_token
    refresh! if expired?
    access_token
  end

end
