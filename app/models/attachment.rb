class Attachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :incoming_message 
end
