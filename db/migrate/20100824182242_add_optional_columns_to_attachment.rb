class AddOptionalColumnsToAttachment < ActiveRecord::Migration
  def self.up
    add_column :attachments, :attachment_content_type, :string
    add_column :attachments, :attachment_file_size, :integer
    add_column :attachments, :attachment_updated_at, :datetime
  end

  def self.down
    remove_column :attachments, :attachment_updated_at
    remove_column :attachments, :attachment_file_size
    remove_column :attachments, :attachment_content_type
  end
end
