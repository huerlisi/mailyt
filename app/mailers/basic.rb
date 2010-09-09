class Basic < ActionMailer::Base
  # Send text email based on Email object
  def text(email)
    @email = email

    for attachment in @email.attachments
      attachments[attachment.attachment.original_filename] = File.read(attachment.attachment.path)
    end
    
    mail :to => email.to, :from => email.from, :subject => email.subject
  end

  # Just redefine ActionMailer.receive with an additional uid parameter
  def self.receive(raw_mail, uid, email_account)
    ActiveSupport::Notifications.instrument("receive.action_mailer") do |payload|
      mail = Mail.new(raw_mail)
      set_payload_for_mail(payload, mail)
      new.receive(mail, uid, email_account)
    end
  end

  # Recive email
  def receive(mail, uid, email_account)
    mail
    email = Email.new(
      :email_account => email_account,
      :user => email_account.user,
      :uid => uid,
      :message_id => mail.message_id,
      :subject => mail.subject,
      :date => mail.date
    )
    if to = mail.to
      to = to.join(', ') if to.is_a? Array
      email.to = to
    end
    if from = mail.from
      from = from.join(', ') if from.is_a? Array
      email.from = from
    end
    if mail.multipart?
      begin
        email.body = Iconv.conv('UTF-8', mail.text_part.charset, mail.text_part.body.to_s)
      rescue
        email.body = mail.text_part.body.to_s
      end
    else
      email.body = mail.body.to_s
    end
     
    if mail.has_attachments?
      for attachment in mail.attachments
        a = email.attachments.build
        Mail::AttachmentIO.open(attachment) {|string| a.attachment = string}
      end
    end
     
    if mail.in_reply_to
      email.in_reply_to = Email.where(:message_id => mail.in_reply_to).first
    end
     
    return email
  end 
end
