module EmailsHelper
  def mail_address(email, name = nil)
    if name.blank?
      return email
    else
      return "%s <%s>" % [name.strip, email.strip]
    end
  end

  def human_mail_address(email, name = nil)
    if name.blank?
      return email
    else
      return content_tag(:span, name.strip, :title => email.strip)
    end
  end
end
