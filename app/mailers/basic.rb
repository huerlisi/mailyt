class Basic < ActionMailer::Base
  # Send text email based on Email object
  def text(email)
    @email = email

    for attachment in @email.attachments
      attachments[attachment.attachment.original_filename] = File.read(attachment.attachment.path)
    end
    
    mail :to => email.to, :from => email.from, :subject => email.subject
  end

  # Recive email
   def receive(mail)
     mail
     email = Email.new(:message_id => mail.message_id, :subject => mail.subject, :date => mail.date)
     email.to = mail.to.join(', ') unless mail.to.nil?
     email.from = mail.from.join(', ') unless mail.from.nil?

     if mail.multipart?
       email.body = Iconv.conv('UTF-8', mail.parts[0].charset, mail.parts[0].body.to_s)
     else
       email.body = mail.body.to_s
     end
     
     if mail.has_attachments?
       for attachment in mail.attachments
         a = email.attachments.build
         Mail::AttachmentIO.open(attachment) {|string| a.attachment = string}
       end
     end
     
     email.save
     
     return mail
  end 
end
