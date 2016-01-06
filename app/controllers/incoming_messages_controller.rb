class IncomingMessagesController < ApplicationController
  
  before_action :set_user
  before_action :set_incoming_message, only: [:show, :destroy]
  
  def index
    @incoming_messages = @user.incoming_messages
  end

  #показать одно сообщение
  def show
    
  end
  
  # скачать аттачмен сообщения 
  def download
    send_data(@incoming_message.attachment) 
  end

  def destroy
    @incoming_message.destroy
    redirect_to incoming_messages_url, notice: 'Example was successfully destroyed.'
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end
    
    def set_incoming_message
      @incoming_message = IncomingMessage.find(params[:id])
    end
    
end
