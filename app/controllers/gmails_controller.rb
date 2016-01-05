require 'nkf'

class GmailsController < ApplicationController
  def connect_and_archive
    @user = current_user
    @gmail = Gmail.connect(:xoauth2, @user.email, @user.access_token) #  Start an authenticated gmail session
    
    mails = @gmail.inbox.emails(:all).map do |mail| # correct later to :unread!
      email = IncomingMessage.new
      email.mailer = mail_address(mail.from)
      email.title = NKF::nkf('-wm', mail.subject.to_s)
      email.data = mail.date
      email.main_recipient = mail_address(mail.to)
      email.other_recipients = mail.in_reply_to
      email.attachment = save_attaches(mail)
     
      #process body
      if mail.text_part
        email.body = mail.text_part.decoded
      elsif mail.html_part
        email.body = mail.html_part.decoded
      else
        email.body = mail.body.decoded.encode("UTF-8", mail.charset) rescue mail.body.to_s
      end
      email.save!
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
  
  def save_attaches(mail)
    attaches_paths = ""

    if mail.attachments.any? #The method returns true if the block ever returns a value other than false or nil.
      att_fld = SecureRandom.uuid
      Dir::mkdir('public/attachments/' + att_fld)

      mail.attachments.each do |attach|
        File.open('public/attachments/' + att_fld + '/' + attach.filename, 'w') do |attach_file|
          attach_file.binmode
          attach_file.write attach.body   #.decoded
          attaches_paths += ';' if !attaches_paths.empty?
          attaches_paths += 'attachments/' + att_fld + '/' + attach.filename
        end
      end
    end
    attaches_paths
  end
  
end
  
  
  
  
  
