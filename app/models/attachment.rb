class Attachment < ActiveRecord::Base
  has_attached_file :attachment, :styles => { :thumb => "32x32>" }
end
