class IncomingMessage < ActiveRecord::Base
    
  serialize :other_recipients
  serialize :attachment, Array
  
  belongs_to :user

end



