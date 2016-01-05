require 'nkf'

class GmailsController < ApplicationController
  
  #incoming messages controller  action refresh 
  
  def connect_and_archive
    @user = current_user
    @gmail = Gmail.connect(:xoauth2, @user.email, @user.access_token) #  Start an authenticated gmail session
    
    @unread_emails = @gmail.inbox.emails(:unread) # Count All unread emails 

    
    @gmail.inbox.emails(:all).map do |mail| #пусь делает со всеми, а потом передалть на анрид
      
      IncomingMessage.create(
            mailer: mail_address(mail.from),
            title: NKF::nkf('-wm', mail.subject.to_s),
            body: mail.text_part.decoded,
            data: mail.date,
            main_recipient: mail_address(mail.to),
            other_recipients: mail.in_reply_to)
      
    end

   # redirect_to страница где показываются сохраненные письма
  end



   def mail_address(adr)  # МЕТОД ДЛЯ ПРЕОБРАЗОВАНИЯ
      if adr.is_a? Array
        adr.map{ |x| mail_address(x) }.join(', ')
      elsif adr.is_a? Net::IMAP::Address
        res = ''
        res += '"' + adr.name + '" ' if adr.name
        res += "<#{adr.mailbox}@#{adr.host}>"
      else
        res.to_s
      end
   end
  
  
  
end