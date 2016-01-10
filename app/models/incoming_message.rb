class IncomingMessage < ActiveRecord::Base
    
  serialize :attachments, Array
  
  belongs_to :user

  scope :newest_first, lambda { order("incoming_messages.created_at DESC")}
  
  def self.refresh_for(user)
    MailRefresher.new(user).refresh
  end
end







