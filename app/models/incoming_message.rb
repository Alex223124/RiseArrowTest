class IncomingMessage < ActiveRecord::Base
    
  serialize :other_recipients
  serialize :attachment 
  
  belongs_to :user

end



