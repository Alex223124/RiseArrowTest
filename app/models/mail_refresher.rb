require 'iconv'


class MailRefresher
  def initialize(user)   # object througth ORM 
    @user = user 
  end
  
  def user # reader method 
    @user
  end
    
  def refresh
    user.fresh_token 
    
    if user.access_token 
      gmail = Gmail.connect(:xoauth2, user.email, user.access_token) #  Start an authenticated gmail session
      mails = gmail.inbox.emails(:unread)
        if mails.any? # 0 emails?
          mails.each do |mail|
            email = IncomingMessage.create(user_id:           user.id,
                                           mailer:            mail_address(mail.from),
                                           title:             mail.message.subject,
                                           data:              mail.date,
                                           main_recipient:    mail_address(mail.to),
                                           other_recipients:  mail.message.cc,
                                           attachments:       save_attaches(mail).split(","),
                                           body:              process_body(mail))
            mail.mark(:read)
          end 
        end
    end
  end
  

  def process_body(mail) # formatting body of emails
    if(mail &&  mail.text_part && mail.text_part.body)
      m = mail.text_part.body.decoded
      charset = mail.text_part.charset
      text = charset ? Iconv.conv("utf-8", charset, m) : m
      (text.respond_to? :force_encoding) ? text.force_encoding("utf-8") : text
    elsif(mail && mail.body && mail.content_type.to_s.include?("text/plain"))
      m = mail.body.decoded
      charset = mail.charset
      text = charset ? Iconv.conv("utf-8", charset, m) : m
      (text.respond_to? :force_encoding) ? text.force_encoding("utf-8") : text
    else
      nil
    end
  end
  
  def mail_address(adr)  # formatting for email address
    if adr.is_a? Array
      adr.map{ |x| mail_address(x) }.join(', ')
    elsif adr.is_a? Net::IMAP::Address
      res = ''
      res += '"' + adr.name + '" ' if adr.name
      res += "(#{adr.mailbox}@#{adr.host})"
      Mail::Encodings.value_decode(res).to_s
    else
      res.to_s
    end
  end
  
  def save_attaches(mail) # saving emails attachments 
    attaches_paths = ""

    Dir.chdir(Rails.root) do
      if mail.attachments.any? # true if the block ever returns a value other than false or nil
        att_fld = SecureRandom.uuid
        Dir::mkdir('public/attachments/' + att_fld)
  
        mail.attachments.each do |attach|
          File.open('public/attachments/' + att_fld + '/' + attach.filename, 'w') do |attach_file|
            attach_file.binmode
            attach_file.write attach.body   #.decoded
            attaches_paths += ',' if !attaches_paths.empty?
            attaches_paths += 'attachments/' + att_fld + '/' + attach.filename 
          end
        end
      end
    end
    attaches_paths
  end

end