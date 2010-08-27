class AddUserReferenceToTables < ActiveRecord::Migration
  def self.up
    add_column :emails, :user_id, :integer
    add_column :email_accounts, :user_id, :integer
    add_column :attachments, :user_id, :integer
  end

  def self.down
    remove_column :emails, :user_id
    remove_column :email_accounts, :user_id
    remove_column :attachments, :user_id
  end
end
