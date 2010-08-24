class AddTitleToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :title, :string
  end

  def self.down
    remove_column :attachments, :title
  end
end
