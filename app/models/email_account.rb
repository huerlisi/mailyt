class EmailAccount < ActiveRecord::Base
  # Associations
  belongs_to :user

  # Helpers
  def to_s
    return "" unless username.present? and server.present?
    
    return "%s@%s" % [username, server]
  end
end
