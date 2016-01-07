require 'nkf'

class MailRefresher
  def initialize(user)   # object througth ORM 
    @user = user 
  end
  
  def user # reader method 
    @user
  end
  
  def refresh
    user.fresh_token 
    
    if user.access_token # for rspec tests and potential devise standart auth
      gmail = Gmail.connect(:xoauth2, user.email, user.access_token) #  Start an authenticated gmail session
      mails = gmail.inbox.emails(:all) # correct later to :unread!
        if mails.any? # 0 emails?
          mails.each do |mail|
            email = IncomingMessage.create(user_id:           user.id,
                                           mailer:            mail_address(mail.from),
                                           title:             NKF::nkf('-wm', mail.subject.to_s),
                                           data:              mail.date,
                                           main_recipient:    mail_address(mail.to),
                                           other_recipients:  mail.in_reply_to,
                                           attachments:       save_attaches(mail).split(","),
                                           body:              process_body(mail))
            #mail.mark(:read) uncomment later
          end
        end
    end
  end

  def process_body(mail) # formatting for body
    if mail.text_part
      mail.text_part.decoded
    elsif mail.html_part
      mail.html_part.decoded
    else
      mail.body.decoded.encode("UTF-8", mail.charset) rescue mail.body.to_s
    end
      # email.save!
  end
  
   def mail_address(adr)  # formatting for email adress
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

  def save_attaches(mail) # saving emails attachments 
    attaches_paths = ""

    if mail.attachments.any? #The method returns true if the block ever returns a value other than false or nil.
      att_fld = SecureRandom.uuid
      Dir::mkdir('public/attachments/' + att_fld)

      mail.attachments.each do |attach|
        File.open('public/attachments/' + att_fld + '/' + attach.filename, 'w') do |attach_file|
          attach_file.binmode
          attach_file.write attach.body   #.decoded
          attaches_paths += ',' if !attaches_paths.empty?
          attaches_paths += attach.filename
        end
      end
    end
    attaches_paths
  end

end