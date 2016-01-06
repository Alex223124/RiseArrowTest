class IncomingMessagesController < ApplicationController
  
  before_action :set_user
  
  def index
    @incoming_messages = @user.incoming_messages
  end

  def show
  end

  def destroy
    @incoming_message.destroy
    redirect_to incoming_messages_url, notice: 'Example was successfully destroyed.'
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end
    
end
