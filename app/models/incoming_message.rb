class IncomingMessage < ActiveRecord::Base
    
  serialize :other_recipients
  
  belongs_to :user
  has_many :attachments
end
