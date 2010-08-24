class Attachment < ActiveRecord::Base
  # Associations
  belongs_to :email
  has_attached_file :attachment, :styles => { :thumb => "32x32>" }
end
