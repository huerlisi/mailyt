class RenameMailsToEmailsTable < ActiveRecord::Migration
  def self.up
    rename_table :mails, :emails
  end

  def self.down
    rename_table :emails, :mails
  end
end
