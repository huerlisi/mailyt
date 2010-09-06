class AddFolderIdToEmails < ActiveRecord::Migration
  def self.up
    add_column :emails, :folder_id, :integer
  end

  def self.down
    remove_column :emails, :folder_id
  end
end
