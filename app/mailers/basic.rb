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
     email = Email.new(:subject => mail.subject, :to => mail.to.join(', '), :from => mail.from.join(', '))

     if mail.multipart?
       email.body = mail.parts[0].body.to_s
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
