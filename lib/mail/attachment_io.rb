class Mail::AttachmentIO < StringIO
  def initialize(attachment)
    @attachment = attachment
    super(@attachment.body.to_s)
  end
  
  def original_filename
    @attachment.filename
  end
  
  def content_type
    @attachment.mime_type
  end
end
