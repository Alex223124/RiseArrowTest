class IncomingMessage < ActiveRecord::Base
    
  serialize :other_recipients, Array
  serialize :attachments, Array
  
  belongs_to :user
  
  def self.refresh_for(user)
    MailRefresher.new(user).refresh
  end
end







