module EmailsHelper
  def mail_address(email, name = nil)
    if name.blank?
      return email
    else
      return "%s <%s>" % [name.strip, email.strip]
    end
  end
end
