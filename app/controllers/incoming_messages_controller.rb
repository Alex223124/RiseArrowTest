class IncomingMessagesController < ApplicationController
  
  before_action :set_user
  before_action :set_incoming_message, except: [:index, :refresh_emails]
  
  
  def index
    @incoming_messages = @user.incoming_messages.paginate(:page => params[:page], :per_page => 50).newest_first
  end

  # Show one message 
  def show
  end
  
  # Download button
  def download
    send_data(@incoming_message.attachments) 
  end

  def destroy
    @incoming_message.destroy
    redirect_to incoming_messages_url, notice: 'Message was successfully destroyed.'
  end
  
  # Refresh button
  def refresh_emails
    IncomingMessage.refresh_for(current_user)
    redirect_to incoming_messages_path, notice: t(:list_of_email_updated) 
  end


  private

    def set_user
      @user = User.find(current_user.id)
    end
    
    def set_incoming_message
      @incoming_message = IncomingMessage.find(params[:id])
    end
    
end
